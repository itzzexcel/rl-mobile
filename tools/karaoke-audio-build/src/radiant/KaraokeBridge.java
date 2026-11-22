package radiant;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.os.Parcel;
import android.os.SharedMemory;
import android.os.SystemClock;
import android.util.Log;
import android.widget.Toast;

import java.nio.ByteBuffer;

/**
 * On-demand Android Binder + SharedMemory bridge from patched TIDAL to
 * com.meowarex.rlmobile.qnn/.karaoke.KaraokeRelayService.
 * Holds zero threads, zero sockets, and zero NPU memory while disabled.
 */
public final class KaraokeBridge {
    private static final String TAG = "RLKaraokeBridge";
    private static final String MANAGER_QNN_PKG = "com.meowarex.rlmobile.qnn";
    private static final String MANAGER_STD_PKG = "com.meowarex.rlmobile";
    private static final String RELAY_CLS = "com.meowarex.rlmobile.karaoke.KaraokeRelayService";
    private static final String DESCRIPTOR = "radiant.karaoke.IRelay";

    private static final int TX_GET_STATUS = IBinder.FIRST_CALL_TRANSACTION;
    private static final int TX_SEPARATE_PCM = IBinder.FIRST_CALL_TRANSACTION + 1;
    private static final int TX_UNLOAD = IBinder.FIRST_CALL_TRANSACTION + 2;
    private static final int TX_SEPARATE_HOP = IBinder.FIRST_CALL_TRANSACTION + 3;

    private static final Object LOCK = new Object();
    private static final Handler MAIN = new Handler(Looper.getMainLooper());

    private static volatile boolean enabled = false;
    private static volatile String mode = "karaoke";
    private static volatile float vocalGain = 0.0f;
    private static volatile String lastProvider = "Idle";
    private static volatile double lastMs = 0.0;
    private static volatile int chunkFrames = 261120;
    private static volatile boolean karaInstalled = true;
    private static volatile boolean instInstalled = true;

    private static IBinder serviceBinder;
    private static boolean bound;
    private static Context boundContext;

    private static final ServiceConnection CONN = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder binder) {
            synchronized (LOCK) {
                serviceBinder = binder;
                LOCK.notifyAll();
            }
            queryStatusAsync();
            Log.i(TAG, "Bound to KaraokeRelayService: " + name.flattenToShortString());
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            synchronized (LOCK) {
                serviceBinder = null;
                LOCK.notifyAll();
            }
            lastProvider = "Idle";
        }
    };

    private KaraokeBridge() {}

    public static boolean isEnabled() {
        return enabled;
    }

    public static String getMode() {
        return mode;
    }

    public static float getVocalGain() {
        return vocalGain;
    }

    public static String getLastProvider() {
        return lastProvider;
    }

    public static double getLastMs() {
        return lastMs;
    }

    public static int getChunkFrames() {
        return chunkFrames;
    }

    public static void setMode(Context ctx, String nextMode) {
        mode = "instrumental".equalsIgnoreCase(nextMode) ? "instrumental" : "karaoke";
        if (enabled && ctx != null) {
            toast(ctx, "Mode: " + ("instrumental".equals(mode) ? "Inst_HQ_3" : "KARA_2"));
        }
    }

    public static void setVocalGain(Context ctx, float gain) {
        if (gain < 0f) gain = 0f;
        if (gain > 1f) gain = 1f;
        vocalGain = gain;
    }

    public static void cycleVocalGain(Context ctx) {
        if (vocalGain < 0.10f) {
            vocalGain = 0.20f;
        } else if (vocalGain < 0.35f) {
            vocalGain = 0.45f;
        } else {
            vocalGain = 0.0f;
        }
    }

    public static void toggle(Context ctx) {
        setEnabled(ctx, !enabled);
    }

    public static void setEnabled(Context ctx, boolean next) {
        final Context app = ctx != null ? ctx.getApplicationContext() : appContext();
        enabled = next;
        KaraokeButton.syncState(next);

        if (next) {
            ensureBound(app);
            String label = "instrumental".equals(mode) ? "Inst_HQ_3" : "KARA_2";
            toast(app, "Karaoke NPU: ON (" + label + ")");
        } else {
            unbindAndUnload();
            lastProvider = "Idle";
            toast(app, "Karaoke NPU: OFF");
        }
    }

    private static void toast(final Context ctx, final String msg) {
        if (ctx == null) return;
        MAIN.post(new Runnable() {
            @Override
            public void run() {
                try {
                    Toast.makeText(ctx, msg, Toast.LENGTH_SHORT).show();
                } catch (Throwable ignored) {}
            }
        });
    }

    private static Context appContext() {
        try {
            return (Context) Class.forName("android.app.ActivityThread")
                    .getMethod("currentApplication").invoke(null);
        } catch (Throwable t) {
            return null;
        }
    }

    private static void ensureBound(Context app) {
        if (app == null) return;
        synchronized (LOCK) {
            if (bound && serviceBinder != null && serviceBinder.isBinderAlive()) {
                return;
            }
            boundContext = app;
            boolean ok = false;
            try {
                Intent i1 = new Intent().setComponent(new ComponentName(MANAGER_QNN_PKG, RELAY_CLS));
                ok = app.bindService(i1, CONN, Context.BIND_AUTO_CREATE);
            } catch (Throwable t) {
                Log.w(TAG, "Bind qnn failed: " + t.getMessage());
            }
            if (!ok) {
                try {
                    Intent i2 = new Intent().setComponent(new ComponentName(MANAGER_STD_PKG, RELAY_CLS));
                    ok = app.bindService(i2, CONN, Context.BIND_AUTO_CREATE);
                } catch (Throwable t) {
                    Log.w(TAG, "Bind std failed: " + t.getMessage());
                }
            }
            bound = ok;
            if (!ok) {
                Log.w(TAG, "KaraokeRelayService not reachable; disabling");
                enabled = false;
                KaraokeButton.syncState(false);
                toast(app, "Install Radiant Manager QNN first");
            }
        }
    }

    private static void unbindAndUnload() {
        IBinder b;
        Context c;
        boolean wasBound;
        synchronized (LOCK) {
            b = serviceBinder;
            c = boundContext;
            wasBound = bound;
            serviceBinder = null;
            bound = false;
            boundContext = null;
        }
        if (b != null) {
            Parcel data = Parcel.obtain();
            Parcel reply = Parcel.obtain();
            try {
                data.writeInterfaceToken(DESCRIPTOR);
                b.transact(TX_UNLOAD, data, reply, 0);
                reply.readException();
            } catch (Throwable ignored) {
            } finally {
                data.recycle();
                reply.recycle();
            }
        }
        if (wasBound && c != null) {
            try {
                c.unbindService(CONN);
            } catch (Throwable ignored) {}
        }
    }

    private static void queryStatusAsync() {
        Thread t = new Thread(new Runnable() {
            @Override
            public void run() {
                IBinder b;
                synchronized (LOCK) {
                    b = serviceBinder;
                }
                if (b == null) return;
                Parcel data = Parcel.obtain();
                Parcel reply = Parcel.obtain();
                try {
                    data.writeInterfaceToken(DESCRIPTOR);
                    data.writeString(mode);
                    if (b.transact(TX_GET_STATUS, data, reply, 0)) {
                        reply.readException();
                        karaInstalled = reply.readInt() != 0;
                        instInstalled = reply.readInt() != 0;
                        String prov = reply.readString();
                        if (prov != null) lastProvider = prov;
                        lastMs = reply.readDouble();
                        int cf = reply.readInt();
                        if (cf >= 4096 && cf <= 524288) chunkFrames = cf;
                    }
                } catch (Throwable t2) {
                    Log.w(TAG, "Status check error: " + t2.getMessage());
                } finally {
                    data.recycle();
                    reply.recycle();
                }
            }
        }, "Karaoke-Status");
        t.setDaemon(true);
        t.start();
    }

    public static byte[] separatePcm(String reqMode, byte[] dryBytes) {
        if (dryBytes == null || dryBytes.length < 4) return dryBytes;
        return separateInternal(TX_SEPARATE_PCM, reqMode, dryBytes, 0, dryBytes.length / 4);
    }

    public static byte[] separateHop(String reqMode, byte[] windowDryBytes, int outStartFrame, int outFrames) {
        if (windowDryBytes == null || outFrames <= 0) return windowDryBytes;
        return separateInternal(TX_SEPARATE_HOP, reqMode, windowDryBytes, outStartFrame, outFrames);
    }

    private static byte[] separateInternal(int txCode, String reqMode, byte[] dryBytes, int outStartFrame, int outFrames) {
        int outByteLen = outFrames * 4;
        if (!enabled || dryBytes == null || dryBytes.length < 4) {
            return sliceDryFallback(dryBytes, outStartFrame * 4, outByteLen);
        }
        IBinder b = awaitBinder(3500L);
        if (b == null) {
            return sliceDryFallback(dryBytes, outStartFrame * 4, outByteLen);
        }

        SharedMemory shm = null;
        ByteBuffer mapped = null;
        Parcel data = Parcel.obtain();
        Parcel reply = Parcel.obtain();
        try {
            shm = SharedMemory.create("rl_kara", dryBytes.length);
            mapped = shm.mapReadWrite();
            mapped.position(0);
            mapped.put(dryBytes, 0, dryBytes.length);

            data.writeInterfaceToken(DESCRIPTOR);
            data.writeString(reqMode);
            data.writeInt(dryBytes.length);
            if (txCode == TX_SEPARATE_HOP) {
                data.writeInt(outStartFrame);
                data.writeInt(outFrames);
            }
            shm.writeToParcel(data, 0);

            boolean txOk = b.transact(txCode, data, reply, 0);
            if (!txOk) {
                return sliceDryFallback(dryBytes, outStartFrame * 4, outByteLen);
            }
            reply.readException();
            int ok = reply.readInt();
            if (ok != 1) {
                String err = reply.readString();
                Log.w(TAG, "Relay returned failure: " + err);
                return sliceDryFallback(dryBytes, outStartFrame * 4, outByteLen);
            }
            String prov = reply.readString();
            double ms = reply.readDouble();
            if (prov != null) lastProvider = prov;
            lastMs = ms;

            byte[] out = new byte[outByteLen];
            mapped.position(0);
            mapped.get(out, 0, out.length);
            return out;
        } catch (Throwable t) {
            Log.w(TAG, "separate Binder error: " + t.getMessage());
            return sliceDryFallback(dryBytes, outStartFrame * 4, outByteLen);
        } finally {
            if (mapped != null) {
                try { SharedMemory.unmap(mapped); } catch (Throwable ignored) {}
            }
            if (shm != null) {
                try { shm.close(); } catch (Throwable ignored) {}
            }
            data.recycle();
            reply.recycle();
        }
    }

    private static byte[] sliceDryFallback(byte[] src, int off, int len) {
        if (src == null) return null;
        if (off == 0 && len == src.length) return src;
        byte[] out = new byte[len];
        if (off >= 0 && off < src.length) {
            System.arraycopy(src, off, out, 0, Math.min(len, src.length - off));
        }
        return out;
    }

    private static IBinder awaitBinder(long timeoutMs) {
        Context app = appContext();
        ensureBound(app);
        long deadline = SystemClock.uptimeMillis() + timeoutMs;
        synchronized (LOCK) {
            while ((serviceBinder == null || !serviceBinder.isBinderAlive()) && enabled) {
                long left = deadline - SystemClock.uptimeMillis();
                if (left <= 0L) break;
                try {
                    LOCK.wait(left);
                } catch (InterruptedException e) {
                    break;
                }
            }
            return serviceBinder;
        }
    }
}

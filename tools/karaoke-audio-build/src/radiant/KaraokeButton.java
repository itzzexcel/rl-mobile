package radiant;

import android.content.Context;
import android.content.res.Resources;
import android.os.Handler;
import android.os.Looper;
import android.view.HapticFeedbackConstants;
import android.view.View;

import androidx.compose.runtime.Composer;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.ui.Modifier;
import androidx.compose.ui.graphics.painter.Painter;
import androidx.compose.ui.platform.AndroidCompositionLocals_androidKt;
import androidx.compose.ui.res.PainterResources_androidKt;

import com.squareup.ui.market.components.MarketIconButtonKt;
import com.squareup.ui.market.core.components.properties.IconButton;
import com.squareup.ui.market.core.theme.d0;
import com.squareup.ui.market.core.theme.k;
import com.tidal.android.feature.playerscreen.ui.composables.anim.BouncePressKt;

import w10.u1;

/**
 * Native MarketIconButton Microphone placed in TIDAL's Player Screen action bar.
 * Short tap: instant Karaoke NPU ON/OFF. Long press: opens KaraokeMenu sheet.
 */
public final class KaraokeButton implements yl0.a, yl0.p, Runnable {
    private static final int KIND_CLICK = 0;
    private static final int KIND_LONG = 1;
    private static final int KIND_ICON_OFF = 2;
    private static final int KIND_ICON_ON = 3;
    private static final int KIND_SYNC = 4;

    private static final KaraokeButton CLICK_FN = new KaraokeButton(KIND_CLICK);
    private static final KaraokeButton LONG_FN = new KaraokeButton(KIND_LONG);
    private static final KaraokeButton ICON_OFF_FN = new KaraokeButton(KIND_ICON_OFF);
    private static final KaraokeButton ICON_ON_FN = new KaraokeButton(KIND_ICON_ON);
    private static final KaraokeButton SYNC_FN = new KaraokeButton(KIND_SYNC);

    private static final Handler MAIN = new Handler(Looper.getMainLooper());
    private static final MutableState ENABLED_STATE =
            SnapshotStateKt.mutableStateOf$default(Boolean.FALSE, null, 2, null);

    private static View hostView;
    private static Context appContext;
    private static int cachedIconId;
    private static volatile boolean pendingEnabled;

    private final int kind;

    private KaraokeButton(int kind) {
        this.kind = kind;
    }

    public static void syncState(boolean on) {
        pendingEnabled = on;
        if (Looper.myLooper() == Looper.getMainLooper()) {
            ENABLED_STATE.setValue(Boolean.valueOf(on));
        } else {
            MAIN.post(SYNC_FN);
        }
    }

    /** Called directly before QueueButton (h3.a) in PlayerScreenKt.e. */
    public static void a(Composer composer) {
        composer.startReplaceGroup(0x524b4152);
        try {
            try {
                Object v = composer.consume(AndroidCompositionLocals_androidKt.getLocalView());
                if (v instanceof View) {
                    hostView = (View) v;
                    Context c = ((View) v).getContext();
                    if (c != null) appContext = c.getApplicationContext();
                }
            } catch (Throwable ignored) {}

            int iconId = resolveMicIconId();
            if (iconId == 0) {
                return;
            }

            Boolean onObj = (Boolean) ENABLED_STATE.getValue();
            boolean on = onObj != null && onObj.booleanValue();

            u1 style = MarketIconButtonKt.P(
                    d0.t(k.e, composer, 6),
                    IconButton.Size.MEDIUM,
                    IconButton.Rank.SECONDARY,
                    null,
                    4,
                    null
            );
            Modifier mod = BouncePressKt.a(Modifier.Companion);

            MarketIconButtonKt.c(
                    CLICK_FN,
                    "Karaoke",
                    mod,
                    null,
                    true,
                    null,
                    LONG_FN,
                    "Karaoke options",
                    style,
                    on ? ICON_ON_FN : ICON_OFF_FN,
                    composer,
                    0x6,
                    0x28
            );
        } finally {
            composer.endReplaceGroup();
        }
    }

    private static int resolveMicIconId() {
        if (cachedIconId != 0) return cachedIconId;
        Context c = appContext;
        if (c == null) {
            try {
                c = (Context) Class.forName("android.app.ActivityThread")
                        .getMethod("currentApplication").invoke(null);
            } catch (Throwable ignored) {}
        }
        if (c == null) return 0;
        Resources r = c.getResources();
        String pkg;
        try {
            pkg = r.getResourcePackageName(com.aspiro.wamp.R.drawable.ic_music_note);
        } catch (Throwable t) {
            pkg = c.getPackageName();
        }
        int id = r.getIdentifier("ic_objects_mic_medium", "drawable", pkg);
        if (id == 0) id = r.getIdentifier("ic_objects_mic_large", "drawable", pkg);
        if (id == 0) id = com.aspiro.wamp.R.drawable.ic_music_note;
        cachedIconId = id;
        return id;
    }

    @Override
    public Object invoke() {
        if (kind == KIND_LONG) {
            View v = hostView;
            if (v != null) {
                try {
                    v.performHapticFeedback(HapticFeedbackConstants.LONG_PRESS);
                } catch (Throwable ignored) {}
                KaraokeMenu.open(v);
            }
        } else {
            Context c = appContext != null ? appContext : (hostView != null ? hostView.getContext() : null);
            KaraokeBridge.toggle(c);
        }
        return kotlin.u.a;
    }

    @Override
    public Object invoke(Object arg1, Object arg2) {
        Composer c = (Composer) arg1;
        int key = kind == KIND_ICON_ON ? 0x524b4901 : 0x524b4900;
        c.startReplaceGroup(key);
        try {
            Painter base = PainterResources_androidKt.painterResource(cachedIconId, c, 0);
            return kind == KIND_ICON_ON ? KaraokeMicPainter.cyan(base) : base;
        } finally {
            c.endReplaceGroup();
        }
    }

    @Override
    public void run() {
        ENABLED_STATE.setValue(Boolean.valueOf(pendingEnabled));
    }
}

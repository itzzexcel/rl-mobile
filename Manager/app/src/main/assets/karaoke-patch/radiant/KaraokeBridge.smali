.class public final Lradiant/KaraokeBridge;
.super Ljava/lang/Object;
.source "KaraokeBridge.java"


# static fields
.field private static final CONN:Landroid/content/ServiceConnection;

.field private static final DESCRIPTOR:Ljava/lang/String; = "radiant.karaoke.IRelay"

.field private static final LOCK:Ljava/lang/Object;

.field private static final MAIN:Landroid/os/Handler;

.field private static final MANAGER_QNN_PKG:Ljava/lang/String; = "com.meowarex.rlmobile.qnn"

.field private static final MANAGER_STD_PKG:Ljava/lang/String; = "com.meowarex.rlmobile"

.field private static final MAX_CONSECUTIVE_FAILURES:I = 0x2

.field private static final RELAY_CLS:Ljava/lang/String; = "com.meowarex.rlmobile.karaoke.KaraokeRelayService"

.field private static final TAG:Ljava/lang/String; = "RLKaraokeBridge"

.field private static final TX_GET_STATUS:I = 0x1

.field private static final TX_SEPARATE_HOP:I = 0x4

.field private static final TX_SEPARATE_PCM:I = 0x2

.field private static final TX_UNLOAD:I = 0x3

.field private static bound:Z

.field private static boundContext:Landroid/content/Context;

.field private static volatile chunkFrames:I

.field private static volatile consecutiveFailures:I

.field private static volatile enabled:Z

.field private static volatile instInstalled:Z

.field private static volatile intentionalUnbind:Z

.field private static volatile karaInstalled:Z

.field private static volatile lastMs:D

.field private static volatile lastProvider:Ljava/lang/String;

.field private static volatile mode:Ljava/lang/String;

.field private static serviceBinder:Landroid/os/IBinder;

.field private static volatile vocalGain:F


# direct methods
.method static bridge synthetic -$$Nest$sfgetLOCK()Ljava/lang/Object;
    .registers 1

    sget-object v0, Lradiant/KaraokeBridge;->LOCK:Ljava/lang/Object;

    return-object v0
.end method

.method static bridge synthetic -$$Nest$sfgetboundContext()Landroid/content/Context;
    .registers 1

    sget-object v0, Lradiant/KaraokeBridge;->boundContext:Landroid/content/Context;

    return-object v0
.end method

.method static bridge synthetic -$$Nest$sfgetenabled()Z
    .registers 1

    sget-boolean v0, Lradiant/KaraokeBridge;->enabled:Z

    return v0
.end method

.method static bridge synthetic -$$Nest$sfgetintentionalUnbind()Z
    .registers 1

    sget-boolean v0, Lradiant/KaraokeBridge;->intentionalUnbind:Z

    return v0
.end method

.method static bridge synthetic -$$Nest$sfgetmode()Ljava/lang/String;
    .registers 1

    sget-object v0, Lradiant/KaraokeBridge;->mode:Ljava/lang/String;

    return-object v0
.end method

.method static bridge synthetic -$$Nest$sfgetserviceBinder()Landroid/os/IBinder;
    .registers 1

    sget-object v0, Lradiant/KaraokeBridge;->serviceBinder:Landroid/os/IBinder;

    return-object v0
.end method

.method static bridge synthetic -$$Nest$sfputchunkFrames(I)V
    .registers 1

    sput p0, Lradiant/KaraokeBridge;->chunkFrames:I

    return-void
.end method

.method static bridge synthetic -$$Nest$sfputinstInstalled(Z)V
    .registers 1

    sput-boolean p0, Lradiant/KaraokeBridge;->instInstalled:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$sfputkaraInstalled(Z)V
    .registers 1

    sput-boolean p0, Lradiant/KaraokeBridge;->karaInstalled:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$sfputlastMs(D)V
    .registers 2

    sput-wide p0, Lradiant/KaraokeBridge;->lastMs:D

    return-void
.end method

.method static bridge synthetic -$$Nest$sfputlastProvider(Ljava/lang/String;)V
    .registers 1

    sput-object p0, Lradiant/KaraokeBridge;->lastProvider:Ljava/lang/String;

    return-void
.end method

.method static bridge synthetic -$$Nest$sfputserviceBinder(Landroid/os/IBinder;)V
    .registers 1

    sput-object p0, Lradiant/KaraokeBridge;->serviceBinder:Landroid/os/IBinder;

    return-void
.end method

.method static bridge synthetic -$$Nest$smappContext()Landroid/content/Context;
    .registers 1

    invoke-static {}, Lradiant/KaraokeBridge;->appContext()Landroid/content/Context;

    move-result-object v0

    return-object v0
.end method

.method static bridge synthetic -$$Nest$smqueryStatusAsync()V
    .registers 0

    invoke-static {}, Lradiant/KaraokeBridge;->queryStatusAsync()V

    return-void
.end method

.method static bridge synthetic -$$Nest$smtripCircuitBreaker(Landroid/content/Context;Ljava/lang/String;)V
    .registers 2

    invoke-static {p0, p1}, Lradiant/KaraokeBridge;->tripCircuitBreaker(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method

.method static constructor <clinit>()V
    .registers 3

    .line 38
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lradiant/KaraokeBridge;->LOCK:Ljava/lang/Object;

    .line 39
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v0, Lradiant/KaraokeBridge;->MAIN:Landroid/os/Handler;

    .line 41
    const/4 v0, 0x0

    sput-boolean v0, Lradiant/KaraokeBridge;->enabled:Z

    .line 42
    const-string v1, "karaoke"

    sput-object v1, Lradiant/KaraokeBridge;->mode:Ljava/lang/String;

    .line 43
    const/4 v1, 0x0

    sput v1, Lradiant/KaraokeBridge;->vocalGain:F

    .line 44
    const-string v1, "Idle"

    sput-object v1, Lradiant/KaraokeBridge;->lastProvider:Ljava/lang/String;

    .line 45
    const-wide/16 v1, 0x0

    sput-wide v1, Lradiant/KaraokeBridge;->lastMs:D

    .line 46
    const v1, 0x3fc00

    sput v1, Lradiant/KaraokeBridge;->chunkFrames:I

    .line 47
    const/4 v1, 0x1

    sput-boolean v1, Lradiant/KaraokeBridge;->karaInstalled:Z

    .line 48
    sput-boolean v1, Lradiant/KaraokeBridge;->instInstalled:Z

    .line 49
    sput v0, Lradiant/KaraokeBridge;->consecutiveFailures:I

    .line 50
    sput-boolean v0, Lradiant/KaraokeBridge;->intentionalUnbind:Z

    .line 56
    new-instance v0, Lradiant/KaraokeBridge$1;

    invoke-direct {v0}, Lradiant/KaraokeBridge$1;-><init>()V

    sput-object v0, Lradiant/KaraokeBridge;->CONN:Landroid/content/ServiceConnection;

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 86
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static appContext()Landroid/content/Context;
    .registers 5

    .line 188
    const/4 v0, 0x0

    :try_start_1
    const-string v1, "android.app.ActivityThread"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    const-string v2, "currentApplication"

    const/4 v3, 0x0

    new-array v4, v3, [Ljava/lang/Class;

    .line 189
    invoke-virtual {v1, v2, v4}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    new-array v2, v3, [Ljava/lang/Object;

    invoke-virtual {v1, v0, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/content/Context;
    :try_end_18
    .catchall {:try_start_1 .. :try_end_18} :catchall_19

    .line 188
    return-object v1

    .line 190
    :catchall_19
    move-exception v1

    .line 191
    return-object v0
.end method

.method private static awaitBinder(J)Landroid/os/IBinder;
    .registers 8

    .line 402
    invoke-static {}, Lradiant/KaraokeBridge;->appContext()Landroid/content/Context;

    move-result-object v0

    .line 403
    invoke-static {v0}, Lradiant/KaraokeBridge;->ensureBound(Landroid/content/Context;)V

    .line 404
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    add-long/2addr v0, p0

    .line 405
    sget-object p0, Lradiant/KaraokeBridge;->LOCK:Ljava/lang/Object;

    monitor-enter p0

    .line 406
    :goto_f
    :try_start_f
    sget-object p1, Lradiant/KaraokeBridge;->serviceBinder:Landroid/os/IBinder;

    if-eqz p1, :cond_1b

    sget-object p1, Lradiant/KaraokeBridge;->serviceBinder:Landroid/os/IBinder;

    invoke-interface {p1}, Landroid/os/IBinder;->isBinderAlive()Z

    move-result p1

    if-nez p1, :cond_35

    :cond_1b
    sget-boolean p1, Lradiant/KaraokeBridge;->enabled:Z

    if-eqz p1, :cond_35

    .line 407
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v2
    :try_end_23
    .catchall {:try_start_f .. :try_end_23} :catchall_39

    sub-long v2, v0, v2

    .line 408
    const-wide/16 v4, 0x0

    cmp-long p1, v2, v4

    if-gtz p1, :cond_2c

    goto :goto_35

    .line 410
    :cond_2c
    :try_start_2c
    sget-object p1, Lradiant/KaraokeBridge;->LOCK:Ljava/lang/Object;

    invoke-virtual {p1, v2, v3}, Ljava/lang/Object;->wait(J)V
    :try_end_31
    .catch Ljava/lang/InterruptedException; {:try_start_2c .. :try_end_31} :catch_33
    .catchall {:try_start_2c .. :try_end_31} :catchall_39

    .line 413
    nop

    .line 414
    goto :goto_f

    .line 411
    :catch_33
    move-exception p1

    .line 412
    nop

    .line 415
    :cond_35
    :goto_35
    :try_start_35
    sget-object p1, Lradiant/KaraokeBridge;->serviceBinder:Landroid/os/IBinder;

    monitor-exit p0

    return-object p1

    .line 416
    :catchall_39
    move-exception p1

    monitor-exit p0
    :try_end_3b
    .catchall {:try_start_35 .. :try_end_3b} :catchall_39

    throw p1
.end method

.method public static cycleVocalGain(Landroid/content/Context;)V
    .registers 2

    .line 126
    sget p0, Lradiant/KaraokeBridge;->vocalGain:F

    const v0, 0x3dcccccd    # 0.1f

    cmpg-float p0, p0, v0

    if-gez p0, :cond_f

    .line 127
    const p0, 0x3e4ccccd    # 0.2f

    sput p0, Lradiant/KaraokeBridge;->vocalGain:F

    goto :goto_21

    .line 128
    :cond_f
    sget p0, Lradiant/KaraokeBridge;->vocalGain:F

    const v0, 0x3eb33333    # 0.35f

    cmpg-float p0, p0, v0

    if-gez p0, :cond_1e

    .line 129
    const p0, 0x3ee66666    # 0.45f

    sput p0, Lradiant/KaraokeBridge;->vocalGain:F

    goto :goto_21

    .line 131
    :cond_1e
    const/4 p0, 0x0

    sput p0, Lradiant/KaraokeBridge;->vocalGain:F

    .line 133
    :goto_21
    return-void
.end method

.method private static ensureBound(Landroid/content/Context;)V
    .registers 9

    .line 196
    if-nez p0, :cond_3

    return-void

    .line 197
    :cond_3
    sget-object v0, Lradiant/KaraokeBridge;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 198
    :try_start_6
    sget-boolean v1, Lradiant/KaraokeBridge;->bound:Z

    if-eqz v1, :cond_18

    sget-object v1, Lradiant/KaraokeBridge;->serviceBinder:Landroid/os/IBinder;

    if-eqz v1, :cond_18

    sget-object v1, Lradiant/KaraokeBridge;->serviceBinder:Landroid/os/IBinder;

    invoke-interface {v1}, Landroid/os/IBinder;->isBinderAlive()Z

    move-result v1

    if-eqz v1, :cond_18

    .line 199
    monitor-exit v0

    return-void

    .line 201
    :cond_18
    sput-object p0, Lradiant/KaraokeBridge;->boundContext:Landroid/content/Context;
    :try_end_1a
    .catchall {:try_start_6 .. :try_end_1a} :catchall_a3

    .line 202
    nop

    .line 204
    const/4 v1, 0x1

    const/4 v2, 0x0

    :try_start_1d
    new-instance v3, Landroid/content/Intent;

    invoke-direct {v3}, Landroid/content/Intent;-><init>()V

    new-instance v4, Landroid/content/ComponentName;

    const-string v5, "com.meowarex.rlmobile.qnn"

    const-string v6, "com.meowarex.rlmobile.karaoke.KaraokeRelayService"

    invoke-direct {v4, v5, v6}, Landroid/content/ComponentName;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v3, v4}, Landroid/content/Intent;->setComponent(Landroid/content/ComponentName;)Landroid/content/Intent;

    move-result-object v3

    .line 205
    sget-object v4, Lradiant/KaraokeBridge;->CONN:Landroid/content/ServiceConnection;

    invoke-virtual {p0, v3, v4, v1}, Landroid/content/Context;->bindService(Landroid/content/Intent;Landroid/content/ServiceConnection;I)Z

    move-result v3
    :try_end_35
    .catchall {:try_start_1d .. :try_end_35} :catchall_36

    .line 208
    goto :goto_54

    .line 206
    :catchall_36
    move-exception v3

    .line 207
    :try_start_37
    const-string v4, "RLKaraokeBridge"

    invoke-virtual {v3}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v3

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Bind qnn failed: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v4, v3}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_53
    .catchall {:try_start_37 .. :try_end_53} :catchall_a3

    move v3, v2

    .line 209
    :goto_54
    if-nez v3, :cond_8c

    .line 211
    :try_start_56
    new-instance v4, Landroid/content/Intent;

    invoke-direct {v4}, Landroid/content/Intent;-><init>()V

    new-instance v5, Landroid/content/ComponentName;

    const-string v6, "com.meowarex.rlmobile"

    const-string v7, "com.meowarex.rlmobile.karaoke.KaraokeRelayService"

    invoke-direct {v5, v6, v7}, Landroid/content/ComponentName;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v4, v5}, Landroid/content/Intent;->setComponent(Landroid/content/ComponentName;)Landroid/content/Intent;

    move-result-object v4

    .line 212
    sget-object v5, Lradiant/KaraokeBridge;->CONN:Landroid/content/ServiceConnection;

    invoke-virtual {p0, v4, v5, v1}, Landroid/content/Context;->bindService(Landroid/content/Intent;Landroid/content/ServiceConnection;I)Z

    move-result v3
    :try_end_6e
    .catchall {:try_start_56 .. :try_end_6e} :catchall_6f

    .line 215
    goto :goto_8c

    .line 213
    :catchall_6f
    move-exception v1

    .line 214
    :try_start_70
    const-string v4, "RLKaraokeBridge"

    invoke-virtual {v1}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v1

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Bind std failed: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v4, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 217
    :cond_8c
    :goto_8c
    sput-boolean v3, Lradiant/KaraokeBridge;->bound:Z

    .line 218
    if-nez v3, :cond_a1

    .line 219
    const-string v1, "RLKaraokeBridge"

    const-string v3, "KaraokeRelayService not reachable; disabling"

    invoke-static {v1, v3}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 220
    sput-boolean v2, Lradiant/KaraokeBridge;->enabled:Z

    .line 221
    invoke-static {v2}, Lradiant/KaraokeButton;->syncState(Z)V

    .line 222
    const-string v1, "Install Radiant Manager QNN first"

    invoke-static {p0, v1}, Lradiant/KaraokeBridge;->toast(Landroid/content/Context;Ljava/lang/String;)V

    .line 224
    :cond_a1
    monitor-exit v0

    .line 225
    return-void

    .line 224
    :catchall_a3
    move-exception p0

    monitor-exit v0
    :try_end_a5
    .catchall {:try_start_70 .. :try_end_a5} :catchall_a3

    throw p0
.end method

.method public static getChunkFrames()I
    .registers 1

    .line 109
    sget v0, Lradiant/KaraokeBridge;->chunkFrames:I

    return v0
.end method

.method public static getLastMs()D
    .registers 2

    .line 105
    sget-wide v0, Lradiant/KaraokeBridge;->lastMs:D

    return-wide v0
.end method

.method public static getLastProvider()Ljava/lang/String;
    .registers 1

    .line 101
    sget-object v0, Lradiant/KaraokeBridge;->lastProvider:Ljava/lang/String;

    return-object v0
.end method

.method public static getMode()Ljava/lang/String;
    .registers 1

    .line 93
    sget-object v0, Lradiant/KaraokeBridge;->mode:Ljava/lang/String;

    return-object v0
.end method

.method public static getVocalGain()F
    .registers 1

    .line 97
    sget v0, Lradiant/KaraokeBridge;->vocalGain:F

    return v0
.end method

.method public static isEnabled()Z
    .registers 1

    .line 89
    sget-boolean v0, Lradiant/KaraokeBridge;->enabled:Z

    return v0
.end method

.method private static onSeparateFailure(Ljava/lang/String;Z)V
    .registers 4

    .line 384
    sget-boolean v0, Lradiant/KaraokeBridge;->enabled:Z

    if-nez v0, :cond_5

    return-void

    .line 385
    :cond_5
    const/4 v0, 0x2

    if-eqz p1, :cond_a

    move p1, v0

    goto :goto_10

    :cond_a
    sget p1, Lradiant/KaraokeBridge;->consecutiveFailures:I

    add-int/lit8 p1, p1, 0x1

    sput p1, Lradiant/KaraokeBridge;->consecutiveFailures:I

    .line 386
    :goto_10
    if-lt p1, v0, :cond_2c

    .line 387
    invoke-static {}, Lradiant/KaraokeBridge;->appContext()Landroid/content/Context;

    move-result-object p1

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Karaoke disabled: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p1, p0}, Lradiant/KaraokeBridge;->tripCircuitBreaker(Landroid/content/Context;Ljava/lang/String;)V

    .line 389
    :cond_2c
    return-void
.end method

.method private static queryStatusAsync()V
    .registers 3

    .line 261
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lradiant/KaraokeBridge$3;

    invoke-direct {v1}, Lradiant/KaraokeBridge$3;-><init>()V

    const-string v2, "Karaoke-Status"

    invoke-direct {v0, v1, v2}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    .line 292
    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Ljava/lang/Thread;->setDaemon(Z)V

    .line 293
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    .line 294
    return-void
.end method

.method public static separateHop(Ljava/lang/String;[BII)[B
    .registers 5

    .line 302
    if-eqz p1, :cond_b

    if-gtz p3, :cond_5

    goto :goto_b

    .line 303
    :cond_5
    const/4 v0, 0x4

    invoke-static {v0, p0, p1, p2, p3}, Lradiant/KaraokeBridge;->separateInternal(ILjava/lang/String;[BII)[B

    move-result-object p0

    return-object p0

    .line 302
    :cond_b
    :goto_b
    return-object p1
.end method

.method private static separateInternal(ILjava/lang/String;[BII)[B
    .registers 16

    .line 307
    const-string v0, "RLKaraokeBridge"

    mul-int/lit8 v1, p4, 0x4

    .line 308
    sget-boolean v2, Lradiant/KaraokeBridge;->enabled:Z

    const/4 v3, 0x4

    if-eqz v2, :cond_1ba

    if-eqz p2, :cond_1ba

    array-length v2, p2

    if-ge v2, v3, :cond_10

    goto/16 :goto_1ba

    .line 311
    :cond_10
    const-wide/16 v4, 0xdac

    invoke-static {v4, v5}, Lradiant/KaraokeBridge;->awaitBinder(J)Landroid/os/IBinder;

    move-result-object v2

    .line 312
    const/4 v4, 0x0

    if-nez v2, :cond_24

    .line 313
    const-string p0, "Karaoke NPU service unavailable"

    invoke-static {p0, v4}, Lradiant/KaraokeBridge;->onSeparateFailure(Ljava/lang/String;Z)V

    .line 314
    mul-int/2addr p3, v3

    invoke-static {p2, p3, v1}, Lradiant/KaraokeBridge;->sliceDryFallback([BII)[B

    move-result-object p0

    return-object p0

    .line 317
    :cond_24
    nop

    .line 318
    nop

    .line 319
    invoke-static {}, Landroid/os/Parcel;->obtain()Landroid/os/Parcel;

    move-result-object v5

    .line 320
    invoke-static {}, Landroid/os/Parcel;->obtain()Landroid/os/Parcel;

    move-result-object v6

    .line 322
    const/4 v7, 0x0

    :try_start_2f
    const-string v8, "rl_kara"

    array-length v9, p2

    invoke-static {v8, v9}, Landroid/os/SharedMemory;->create(Ljava/lang/String;I)Landroid/os/SharedMemory;

    move-result-object v8
    :try_end_36
    .catch Landroid/os/DeadObjectException; {:try_start_2f .. :try_end_36} :catch_163
    .catchall {:try_start_2f .. :try_end_36} :catchall_126

    .line 323
    :try_start_36
    invoke-virtual {v8}, Landroid/os/SharedMemory;->mapReadWrite()Ljava/nio/ByteBuffer;

    move-result-object v7

    .line 324
    invoke-virtual {v7, v4}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    move-result-object v9

    check-cast v9, Ljava/nio/ByteBuffer;

    .line 325
    array-length v9, p2

    invoke-virtual {v7, p2, v4, v9}, Ljava/nio/ByteBuffer;->put([BII)Ljava/nio/ByteBuffer;

    .line 327
    const-string v9, "radiant.karaoke.IRelay"

    invoke-virtual {v5, v9}, Landroid/os/Parcel;->writeInterfaceToken(Ljava/lang/String;)V

    .line 328
    invoke-virtual {v5, p1}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 329
    array-length p1, p2

    invoke-virtual {v5, p1}, Landroid/os/Parcel;->writeInt(I)V

    .line 330
    if-ne p0, v3, :cond_58

    .line 331
    invoke-virtual {v5, p3}, Landroid/os/Parcel;->writeInt(I)V

    .line 332
    invoke-virtual {v5, p4}, Landroid/os/Parcel;->writeInt(I)V

    .line 334
    :cond_58
    invoke-virtual {v8, v5, v4}, Landroid/os/SharedMemory;->writeToParcel(Landroid/os/Parcel;I)V

    .line 336
    invoke-interface {v2, p0, v5, v6, v4}, Landroid/os/IBinder;->transact(ILandroid/os/Parcel;Landroid/os/Parcel;I)Z

    move-result p0

    .line 337
    if-nez p0, :cond_81

    .line 338
    const-string p0, "Karaoke Binder call failed"

    invoke-static {p0, v4}, Lradiant/KaraokeBridge;->onSeparateFailure(Ljava/lang/String;Z)V

    .line 339
    mul-int/lit8 p0, p3, 0x4

    invoke-static {p2, p0, v1}, Lradiant/KaraokeBridge;->sliceDryFallback([BII)[B

    move-result-object p0
    :try_end_6c
    .catch Landroid/os/DeadObjectException; {:try_start_36 .. :try_end_6c} :catch_122
    .catchall {:try_start_36 .. :try_end_6c} :catchall_120

    .line 372
    if-eqz v7, :cond_73

    .line 373
    :try_start_6e
    invoke-static {v7}, Landroid/os/SharedMemory;->unmap(Ljava/nio/ByteBuffer;)V
    :try_end_71
    .catchall {:try_start_6e .. :try_end_71} :catchall_72

    goto :goto_73

    :catchall_72
    move-exception p1

    .line 375
    :cond_73
    :goto_73
    if-eqz v8, :cond_7a

    .line 376
    :try_start_75
    invoke-virtual {v8}, Landroid/os/SharedMemory;->close()V
    :try_end_78
    .catchall {:try_start_75 .. :try_end_78} :catchall_79

    goto :goto_7a

    :catchall_79
    move-exception p1

    .line 378
    :cond_7a
    :goto_7a
    invoke-virtual {v5}, Landroid/os/Parcel;->recycle()V

    .line 379
    invoke-virtual {v6}, Landroid/os/Parcel;->recycle()V

    .line 339
    return-object p0

    .line 341
    :cond_81
    :try_start_81
    invoke-virtual {v6}, Landroid/os/Parcel;->readException()V

    .line 342
    invoke-virtual {v6}, Landroid/os/Parcel;->readInt()I

    move-result p0

    .line 343
    const/4 p1, 0x1

    if-eq p0, p1, :cond_ef

    .line 344
    invoke-virtual {v6}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object p0

    .line 345
    new-instance p4, Ljava/lang/StringBuilder;

    invoke-direct {p4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Relay returned failure: "

    invoke-virtual {p4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p4

    invoke-virtual {p4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p4

    invoke-virtual {p4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p4

    invoke-static {v0, p4}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 346
    if-eqz p0, :cond_ae

    sget-object p4, Ljava/util/Locale;->US:Ljava/util/Locale;

    invoke-virtual {p0, p4}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object p4

    goto :goto_b0

    :cond_ae
    const-string p4, ""

    .line 347
    :goto_b0
    const-string v2, "outdated fp32"

    invoke-virtual {p4, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-nez v2, :cond_cb

    const-string v2, "not installed"

    .line 348
    invoke-virtual {p4, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-nez v2, :cond_cb

    const-string v2, "unsupported"

    .line 349
    invoke-virtual {p4, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p4

    if-eqz p4, :cond_c9

    goto :goto_cb

    :cond_c9
    move p1, v4

    goto :goto_cc

    :cond_cb
    :goto_cb
    nop

    .line 350
    :goto_cc
    if-eqz p0, :cond_cf

    goto :goto_d1

    :cond_cf
    const-string p0, "QNN separation failed"

    :goto_d1
    invoke-static {p0, p1}, Lradiant/KaraokeBridge;->onSeparateFailure(Ljava/lang/String;Z)V

    .line 351
    mul-int/lit8 p0, p3, 0x4

    invoke-static {p2, p0, v1}, Lradiant/KaraokeBridge;->sliceDryFallback([BII)[B

    move-result-object p0
    :try_end_da
    .catch Landroid/os/DeadObjectException; {:try_start_81 .. :try_end_da} :catch_122
    .catchall {:try_start_81 .. :try_end_da} :catchall_120

    .line 372
    if-eqz v7, :cond_e1

    .line 373
    :try_start_dc
    invoke-static {v7}, Landroid/os/SharedMemory;->unmap(Ljava/nio/ByteBuffer;)V
    :try_end_df
    .catchall {:try_start_dc .. :try_end_df} :catchall_e0

    goto :goto_e1

    :catchall_e0
    move-exception p1

    .line 375
    :cond_e1
    :goto_e1
    if-eqz v8, :cond_e8

    .line 376
    :try_start_e3
    invoke-virtual {v8}, Landroid/os/SharedMemory;->close()V
    :try_end_e6
    .catchall {:try_start_e3 .. :try_end_e6} :catchall_e7

    goto :goto_e8

    :catchall_e7
    move-exception p1

    .line 378
    :cond_e8
    :goto_e8
    invoke-virtual {v5}, Landroid/os/Parcel;->recycle()V

    .line 379
    invoke-virtual {v6}, Landroid/os/Parcel;->recycle()V

    .line 351
    return-object p0

    .line 353
    :cond_ef
    :try_start_ef
    sput v4, Lradiant/KaraokeBridge;->consecutiveFailures:I

    .line 354
    invoke-virtual {v6}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object p0

    .line 355
    invoke-virtual {v6}, Landroid/os/Parcel;->readDouble()D

    move-result-wide v9

    .line 356
    if-eqz p0, :cond_fd

    sput-object p0, Lradiant/KaraokeBridge;->lastProvider:Ljava/lang/String;

    .line 357
    :cond_fd
    sput-wide v9, Lradiant/KaraokeBridge;->lastMs:D

    .line 359
    new-array p0, v1, [B

    .line 360
    invoke-virtual {v7, v4}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    move-result-object p1

    check-cast p1, Ljava/nio/ByteBuffer;

    .line 361
    invoke-virtual {v7, p0, v4, v1}, Ljava/nio/ByteBuffer;->get([BII)Ljava/nio/ByteBuffer;
    :try_end_10a
    .catch Landroid/os/DeadObjectException; {:try_start_ef .. :try_end_10a} :catch_122
    .catchall {:try_start_ef .. :try_end_10a} :catchall_120

    .line 362
    nop

    .line 372
    if-eqz v7, :cond_112

    .line 373
    :try_start_10d
    invoke-static {v7}, Landroid/os/SharedMemory;->unmap(Ljava/nio/ByteBuffer;)V
    :try_end_110
    .catchall {:try_start_10d .. :try_end_110} :catchall_111

    goto :goto_112

    :catchall_111
    move-exception p1

    .line 375
    :cond_112
    :goto_112
    if-eqz v8, :cond_119

    .line 376
    :try_start_114
    invoke-virtual {v8}, Landroid/os/SharedMemory;->close()V
    :try_end_117
    .catchall {:try_start_114 .. :try_end_117} :catchall_118

    goto :goto_119

    :catchall_118
    move-exception p1

    .line 378
    :cond_119
    :goto_119
    invoke-virtual {v5}, Landroid/os/Parcel;->recycle()V

    .line 379
    invoke-virtual {v6}, Landroid/os/Parcel;->recycle()V

    .line 362
    return-object p0

    .line 367
    :catchall_120
    move-exception p0

    goto :goto_128

    .line 363
    :catch_122
    move-exception p0

    move-object p1, v7

    move-object v7, v8

    goto :goto_165

    .line 367
    :catchall_126
    move-exception p0

    move-object v8, v7

    .line 368
    :goto_128
    :try_start_128
    invoke-virtual {p0}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object p0

    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p4, "separate Binder error: "

    invoke-virtual {p1, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 369
    const-string p0, "Karaoke NPU error \u2014 auto-disabled"

    invoke-static {p0, v4}, Lradiant/KaraokeBridge;->onSeparateFailure(Ljava/lang/String;Z)V

    .line 370
    mul-int/2addr p3, v3

    invoke-static {p2, p3, v1}, Lradiant/KaraokeBridge;->sliceDryFallback([BII)[B

    move-result-object p0
    :try_end_14c
    .catchall {:try_start_128 .. :try_end_14c} :catchall_161

    .line 372
    if-eqz v7, :cond_153

    .line 373
    :try_start_14e
    invoke-static {v7}, Landroid/os/SharedMemory;->unmap(Ljava/nio/ByteBuffer;)V
    :try_end_151
    .catchall {:try_start_14e .. :try_end_151} :catchall_152

    goto :goto_153

    :catchall_152
    move-exception p1

    .line 375
    :cond_153
    :goto_153
    if-eqz v8, :cond_15a

    .line 376
    :try_start_155
    invoke-virtual {v8}, Landroid/os/SharedMemory;->close()V
    :try_end_158
    .catchall {:try_start_155 .. :try_end_158} :catchall_159

    goto :goto_15a

    :catchall_159
    move-exception p1

    .line 378
    :cond_15a
    :goto_15a
    invoke-virtual {v5}, Landroid/os/Parcel;->recycle()V

    .line 379
    invoke-virtual {v6}, Landroid/os/Parcel;->recycle()V

    .line 370
    return-object p0

    .line 372
    :catchall_161
    move-exception p0

    goto :goto_1a5

    .line 363
    :catch_163
    move-exception p0

    move-object p1, v7

    .line 364
    :goto_165
    :try_start_165
    invoke-virtual {p0}, Landroid/os/DeadObjectException;->getMessage()Ljava/lang/String;

    move-result-object p0

    new-instance p4, Ljava/lang/StringBuilder;

    invoke-direct {p4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "KaraokeRelayService died during separate: "

    invoke-virtual {p4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p4

    invoke-virtual {p4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 365
    invoke-static {}, Lradiant/KaraokeBridge;->appContext()Landroid/content/Context;

    move-result-object p0

    const-string p4, "Karaoke NPU process died \u2014 auto-disabled"

    invoke-static {p0, p4}, Lradiant/KaraokeBridge;->tripCircuitBreaker(Landroid/content/Context;Ljava/lang/String;)V

    .line 366
    mul-int/2addr p3, v3

    invoke-static {p2, p3, v1}, Lradiant/KaraokeBridge;->sliceDryFallback([BII)[B

    move-result-object p0
    :try_end_18d
    .catchall {:try_start_165 .. :try_end_18d} :catchall_1a2

    .line 372
    if-eqz p1, :cond_194

    .line 373
    :try_start_18f
    invoke-static {p1}, Landroid/os/SharedMemory;->unmap(Ljava/nio/ByteBuffer;)V
    :try_end_192
    .catchall {:try_start_18f .. :try_end_192} :catchall_193

    goto :goto_194

    :catchall_193
    move-exception p1

    .line 375
    :cond_194
    :goto_194
    if-eqz v7, :cond_19b

    .line 376
    :try_start_196
    invoke-virtual {v7}, Landroid/os/SharedMemory;->close()V
    :try_end_199
    .catchall {:try_start_196 .. :try_end_199} :catchall_19a

    goto :goto_19b

    :catchall_19a
    move-exception p1

    .line 378
    :cond_19b
    :goto_19b
    invoke-virtual {v5}, Landroid/os/Parcel;->recycle()V

    .line 379
    invoke-virtual {v6}, Landroid/os/Parcel;->recycle()V

    .line 366
    return-object p0

    .line 372
    :catchall_1a2
    move-exception p0

    move-object v8, v7

    move-object v7, p1

    :goto_1a5
    if-eqz v7, :cond_1ac

    .line 373
    :try_start_1a7
    invoke-static {v7}, Landroid/os/SharedMemory;->unmap(Ljava/nio/ByteBuffer;)V
    :try_end_1aa
    .catchall {:try_start_1a7 .. :try_end_1aa} :catchall_1ab

    goto :goto_1ac

    :catchall_1ab
    move-exception p1

    .line 375
    :cond_1ac
    :goto_1ac
    if-eqz v8, :cond_1b3

    .line 376
    :try_start_1ae
    invoke-virtual {v8}, Landroid/os/SharedMemory;->close()V
    :try_end_1b1
    .catchall {:try_start_1ae .. :try_end_1b1} :catchall_1b2

    goto :goto_1b3

    :catchall_1b2
    move-exception p1

    .line 378
    :cond_1b3
    :goto_1b3
    invoke-virtual {v5}, Landroid/os/Parcel;->recycle()V

    .line 379
    invoke-virtual {v6}, Landroid/os/Parcel;->recycle()V

    .line 380
    throw p0

    .line 309
    :cond_1ba
    :goto_1ba
    mul-int/2addr p3, v3

    invoke-static {p2, p3, v1}, Lradiant/KaraokeBridge;->sliceDryFallback([BII)[B

    move-result-object p0

    return-object p0
.end method

.method public static separatePcm(Ljava/lang/String;[B)[B
    .registers 5

    .line 297
    if-eqz p1, :cond_10

    array-length v0, p1

    const/4 v1, 0x4

    if-ge v0, v1, :cond_7

    goto :goto_10

    .line 298
    :cond_7
    array-length v0, p1

    div-int/2addr v0, v1

    const/4 v1, 0x2

    const/4 v2, 0x0

    invoke-static {v1, p0, p1, v2, v0}, Lradiant/KaraokeBridge;->separateInternal(ILjava/lang/String;[BII)[B

    move-result-object p0

    return-object p0

    .line 297
    :cond_10
    :goto_10
    return-object p1
.end method

.method public static setEnabled(Landroid/content/Context;Z)V
    .registers 4

    .line 140
    if-eqz p0, :cond_7

    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    goto :goto_b

    :cond_7
    invoke-static {}, Lradiant/KaraokeBridge;->appContext()Landroid/content/Context;

    move-result-object p0

    .line 141
    :goto_b
    sput-boolean p1, Lradiant/KaraokeBridge;->enabled:Z

    .line 142
    invoke-static {p1}, Lradiant/KaraokeButton;->syncState(Z)V

    .line 144
    if-eqz p1, :cond_46

    .line 145
    const/4 p1, 0x0

    sput p1, Lradiant/KaraokeBridge;->consecutiveFailures:I

    .line 146
    sput-boolean p1, Lradiant/KaraokeBridge;->intentionalUnbind:Z

    .line 147
    invoke-static {p0}, Lradiant/KaraokeBridge;->ensureBound(Landroid/content/Context;)V

    .line 148
    const-string p1, "instrumental"

    sget-object v0, Lradiant/KaraokeBridge;->mode:Ljava/lang/String;

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_27

    const-string p1, "Inst_HQ_3"

    goto :goto_29

    :cond_27
    const-string p1, "KARA_2"

    .line 149
    :goto_29
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Karaoke NPU: ON ("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v0, ")"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lradiant/KaraokeBridge;->toast(Landroid/content/Context;Ljava/lang/String;)V

    .line 150
    goto :goto_55

    .line 151
    :cond_46
    const/4 p1, 0x1

    sput-boolean p1, Lradiant/KaraokeBridge;->intentionalUnbind:Z

    .line 152
    invoke-static {}, Lradiant/KaraokeBridge;->unbindAndUnload()V

    .line 153
    const-string p1, "Idle"

    sput-object p1, Lradiant/KaraokeBridge;->lastProvider:Ljava/lang/String;

    .line 154
    const-string p1, "Karaoke NPU: OFF"

    invoke-static {p0, p1}, Lradiant/KaraokeBridge;->toast(Landroid/content/Context;Ljava/lang/String;)V

    .line 156
    :goto_55
    return-void
.end method

.method public static setMode(Landroid/content/Context;Ljava/lang/String;)V
    .registers 4

    .line 113
    const-string v0, "instrumental"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_a

    move-object p1, v0

    goto :goto_c

    :cond_a
    const-string p1, "karaoke"

    :goto_c
    sput-object p1, Lradiant/KaraokeBridge;->mode:Ljava/lang/String;

    .line 114
    sget-boolean p1, Lradiant/KaraokeBridge;->enabled:Z

    if-eqz p1, :cond_37

    if-eqz p0, :cond_37

    .line 115
    sget-object p1, Lradiant/KaraokeBridge;->mode:Ljava/lang/String;

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1f

    const-string p1, "Inst_HQ_3"

    goto :goto_21

    :cond_1f
    const-string p1, "KARA_2"

    :goto_21
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Mode: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lradiant/KaraokeBridge;->toast(Landroid/content/Context;Ljava/lang/String;)V

    .line 117
    :cond_37
    return-void
.end method

.method public static setVocalGain(Landroid/content/Context;F)V
    .registers 3

    .line 120
    const/4 p0, 0x0

    cmpg-float v0, p1, p0

    if-gez v0, :cond_6

    move p1, p0

    .line 121
    :cond_6
    const/high16 p0, 0x3f800000    # 1.0f

    cmpl-float v0, p1, p0

    if-lez v0, :cond_d

    move p1, p0

    .line 122
    :cond_d
    sput p1, Lradiant/KaraokeBridge;->vocalGain:F

    .line 123
    return-void
.end method

.method private static sliceDryFallback([BII)[B
    .registers 5

    .line 392
    if-nez p0, :cond_4

    const/4 p0, 0x0

    return-object p0

    .line 393
    :cond_4
    if-nez p1, :cond_a

    array-length v0, p0

    if-ne p2, v0, :cond_a

    return-object p0

    .line 394
    :cond_a
    new-array v0, p2, [B

    .line 395
    if-ltz p1, :cond_1b

    array-length v1, p0

    if-ge p1, v1, :cond_1b

    .line 396
    array-length v1, p0

    sub-int/2addr v1, p1

    invoke-static {p2, v1}, Ljava/lang/Math;->min(II)I

    move-result p2

    const/4 v1, 0x0

    invoke-static {p0, p1, v0, v1, p2}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 398
    :cond_1b
    return-object v0
.end method

.method private static toast(Landroid/content/Context;Ljava/lang/String;)V
    .registers 4

    .line 175
    if-nez p0, :cond_3

    return-void

    .line 176
    :cond_3
    sget-object v0, Lradiant/KaraokeBridge;->MAIN:Landroid/os/Handler;

    new-instance v1, Lradiant/KaraokeBridge$2;

    invoke-direct {v1, p0, p1}, Lradiant/KaraokeBridge$2;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 184
    return-void
.end method

.method public static toggle(Landroid/content/Context;)V
    .registers 2

    .line 136
    sget-boolean v0, Lradiant/KaraokeBridge;->enabled:Z

    xor-int/lit8 v0, v0, 0x1

    invoke-static {p0, v0}, Lradiant/KaraokeBridge;->setEnabled(Landroid/content/Context;Z)V

    .line 137
    return-void
.end method

.method private static tripCircuitBreaker(Landroid/content/Context;Ljava/lang/String;)V
    .registers 6

    .line 160
    sget-object v0, Lradiant/KaraokeBridge;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 161
    :try_start_3
    sget-boolean v1, Lradiant/KaraokeBridge;->enabled:Z

    .line 162
    const/4 v2, 0x0

    if-eqz v1, :cond_11

    .line 163
    sput-boolean v2, Lradiant/KaraokeBridge;->enabled:Z

    .line 164
    const/4 v3, 0x1

    sput-boolean v3, Lradiant/KaraokeBridge;->intentionalUnbind:Z

    .line 165
    const-string v3, "Error"

    sput-object v3, Lradiant/KaraokeBridge;->lastProvider:Ljava/lang/String;

    .line 167
    :cond_11
    monitor-exit v0
    :try_end_12
    .catchall {:try_start_3 .. :try_end_12} :catchall_26

    .line 168
    if-nez v1, :cond_15

    return-void

    .line 169
    :cond_15
    invoke-static {v2}, Lradiant/KaraokeButton;->syncState(Z)V

    .line 170
    invoke-static {}, Lradiant/KaraokeBridge;->unbindAndUnload()V

    .line 171
    if-eqz p0, :cond_1e

    goto :goto_22

    :cond_1e
    invoke-static {}, Lradiant/KaraokeBridge;->appContext()Landroid/content/Context;

    move-result-object p0

    :goto_22
    invoke-static {p0, p1}, Lradiant/KaraokeBridge;->toast(Landroid/content/Context;Ljava/lang/String;)V

    .line 172
    return-void

    .line 167
    :catchall_26
    move-exception p0

    :try_start_27
    monitor-exit v0
    :try_end_28
    .catchall {:try_start_27 .. :try_end_28} :catchall_26

    throw p0
.end method

.method private static unbindAndUnload()V
    .registers 7

    .line 231
    sget-object v0, Lradiant/KaraokeBridge;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 232
    const/4 v1, 0x1

    :try_start_4
    sput-boolean v1, Lradiant/KaraokeBridge;->intentionalUnbind:Z

    .line 233
    sget-object v1, Lradiant/KaraokeBridge;->serviceBinder:Landroid/os/IBinder;

    .line 234
    sget-object v2, Lradiant/KaraokeBridge;->boundContext:Landroid/content/Context;

    .line 235
    sget-boolean v3, Lradiant/KaraokeBridge;->bound:Z

    .line 236
    const/4 v4, 0x0

    sput-object v4, Lradiant/KaraokeBridge;->serviceBinder:Landroid/os/IBinder;

    .line 237
    const/4 v5, 0x0

    sput-boolean v5, Lradiant/KaraokeBridge;->bound:Z

    .line 238
    sput-object v4, Lradiant/KaraokeBridge;->boundContext:Landroid/content/Context;

    .line 239
    monitor-exit v0
    :try_end_15
    .catchall {:try_start_4 .. :try_end_15} :catchall_41

    .line 240
    if-eqz v1, :cond_34

    .line 241
    invoke-static {}, Landroid/os/Parcel;->obtain()Landroid/os/Parcel;

    move-result-object v0

    .line 242
    invoke-static {}, Landroid/os/Parcel;->obtain()Landroid/os/Parcel;

    move-result-object v4

    .line 244
    :try_start_1f
    const-string v6, "radiant.karaoke.IRelay"

    invoke-virtual {v0, v6}, Landroid/os/Parcel;->writeInterfaceToken(Ljava/lang/String;)V

    .line 245
    const/4 v6, 0x3

    invoke-interface {v1, v6, v0, v4, v5}, Landroid/os/IBinder;->transact(ILandroid/os/Parcel;Landroid/os/Parcel;I)Z

    .line 246
    invoke-virtual {v4}, Landroid/os/Parcel;->readException()V
    :try_end_2b
    .catchall {:try_start_1f .. :try_end_2b} :catchall_2c

    goto :goto_2d

    .line 247
    :catchall_2c
    move-exception v1

    .line 249
    :goto_2d
    invoke-virtual {v0}, Landroid/os/Parcel;->recycle()V

    .line 250
    invoke-virtual {v4}, Landroid/os/Parcel;->recycle()V

    .line 251
    nop

    .line 253
    :cond_34
    if-eqz v3, :cond_40

    if-eqz v2, :cond_40

    .line 255
    :try_start_38
    sget-object v0, Lradiant/KaraokeBridge;->CONN:Landroid/content/ServiceConnection;

    invoke-virtual {v2, v0}, Landroid/content/Context;->unbindService(Landroid/content/ServiceConnection;)V
    :try_end_3d
    .catchall {:try_start_38 .. :try_end_3d} :catchall_3e

    goto :goto_3f

    .line 256
    :catchall_3e
    move-exception v0

    :goto_3f
    nop

    .line 258
    :cond_40
    return-void

    .line 239
    :catchall_41
    move-exception v1

    :try_start_42
    monitor-exit v0
    :try_end_43
    .catchall {:try_start_42 .. :try_end_43} :catchall_41

    throw v1
.end method

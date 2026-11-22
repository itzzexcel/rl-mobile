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

.field private static final RELAY_CLS:Ljava/lang/String; = "com.meowarex.rlmobile.karaoke.KaraokeRelayService"

.field private static final TAG:Ljava/lang/String; = "RLKaraokeBridge"

.field private static final TX_GET_STATUS:I = 0x1

.field private static final TX_SEPARATE_HOP:I = 0x4

.field private static final TX_SEPARATE_PCM:I = 0x2

.field private static final TX_UNLOAD:I = 0x3

.field private static bound:Z

.field private static boundContext:Landroid/content/Context;

.field private static volatile chunkFrames:I

.field private static volatile enabled:Z

.field private static volatile instInstalled:Z

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

.method static bridge synthetic -$$Nest$smqueryStatusAsync()V
    .registers 0

    invoke-static {}, Lradiant/KaraokeBridge;->queryStatusAsync()V

    return-void
.end method

.method static constructor <clinit>()V
    .registers 2

    .line 35
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lradiant/KaraokeBridge;->LOCK:Ljava/lang/Object;

    .line 36
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v0, Lradiant/KaraokeBridge;->MAIN:Landroid/os/Handler;

    .line 38
    const/4 v0, 0x0

    sput-boolean v0, Lradiant/KaraokeBridge;->enabled:Z

    .line 39
    const-string v0, "karaoke"

    sput-object v0, Lradiant/KaraokeBridge;->mode:Ljava/lang/String;

    .line 40
    const/4 v0, 0x0

    sput v0, Lradiant/KaraokeBridge;->vocalGain:F

    .line 41
    const-string v0, "Idle"

    sput-object v0, Lradiant/KaraokeBridge;->lastProvider:Ljava/lang/String;

    .line 42
    const-wide/16 v0, 0x0

    sput-wide v0, Lradiant/KaraokeBridge;->lastMs:D

    .line 43
    const v0, 0x3fc00

    sput v0, Lradiant/KaraokeBridge;->chunkFrames:I

    .line 44
    const/4 v0, 0x1

    sput-boolean v0, Lradiant/KaraokeBridge;->karaInstalled:Z

    .line 45
    sput-boolean v0, Lradiant/KaraokeBridge;->instInstalled:Z

    .line 51
    new-instance v0, Lradiant/KaraokeBridge$1;

    invoke-direct {v0}, Lradiant/KaraokeBridge$1;-><init>()V

    sput-object v0, Lradiant/KaraokeBridge;->CONN:Landroid/content/ServiceConnection;

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 72
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static appContext()Landroid/content/Context;
    .registers 5

    .line 155
    const/4 v0, 0x0

    :try_start_1
    const-string v1, "android.app.ActivityThread"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    const-string v2, "currentApplication"

    const/4 v3, 0x0

    new-array v4, v3, [Ljava/lang/Class;

    .line 156
    invoke-virtual {v1, v2, v4}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    new-array v2, v3, [Ljava/lang/Object;

    invoke-virtual {v1, v0, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/content/Context;
    :try_end_18
    .catchall {:try_start_1 .. :try_end_18} :catchall_19

    .line 155
    return-object v1

    .line 157
    :catchall_19
    move-exception v1

    .line 158
    return-object v0
.end method

.method private static awaitBinder(J)Landroid/os/IBinder;
    .registers 8

    .line 347
    invoke-static {}, Lradiant/KaraokeBridge;->appContext()Landroid/content/Context;

    move-result-object v0

    .line 348
    invoke-static {v0}, Lradiant/KaraokeBridge;->ensureBound(Landroid/content/Context;)V

    .line 349
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    add-long/2addr v0, p0

    .line 350
    sget-object p0, Lradiant/KaraokeBridge;->LOCK:Ljava/lang/Object;

    monitor-enter p0

    .line 351
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

    .line 352
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v2
    :try_end_23
    .catchall {:try_start_f .. :try_end_23} :catchall_39

    sub-long v2, v0, v2

    .line 353
    const-wide/16 v4, 0x0

    cmp-long p1, v2, v4

    if-gtz p1, :cond_2c

    goto :goto_35

    .line 355
    :cond_2c
    :try_start_2c
    sget-object p1, Lradiant/KaraokeBridge;->LOCK:Ljava/lang/Object;

    invoke-virtual {p1, v2, v3}, Ljava/lang/Object;->wait(J)V
    :try_end_31
    .catch Ljava/lang/InterruptedException; {:try_start_2c .. :try_end_31} :catch_33
    .catchall {:try_start_2c .. :try_end_31} :catchall_39

    .line 358
    nop

    .line 359
    goto :goto_f

    .line 356
    :catch_33
    move-exception p1

    .line 357
    nop

    .line 360
    :cond_35
    :goto_35
    :try_start_35
    sget-object p1, Lradiant/KaraokeBridge;->serviceBinder:Landroid/os/IBinder;

    monitor-exit p0

    return-object p1

    .line 361
    :catchall_39
    move-exception p1

    monitor-exit p0
    :try_end_3b
    .catchall {:try_start_35 .. :try_end_3b} :catchall_39

    throw p1
.end method

.method public static cycleVocalGain(Landroid/content/Context;)V
    .registers 2

    .line 112
    sget p0, Lradiant/KaraokeBridge;->vocalGain:F

    const v0, 0x3dcccccd    # 0.1f

    cmpg-float p0, p0, v0

    if-gez p0, :cond_f

    .line 113
    const p0, 0x3e4ccccd    # 0.2f

    sput p0, Lradiant/KaraokeBridge;->vocalGain:F

    goto :goto_21

    .line 114
    :cond_f
    sget p0, Lradiant/KaraokeBridge;->vocalGain:F

    const v0, 0x3eb33333    # 0.35f

    cmpg-float p0, p0, v0

    if-gez p0, :cond_1e

    .line 115
    const p0, 0x3ee66666    # 0.45f

    sput p0, Lradiant/KaraokeBridge;->vocalGain:F

    goto :goto_21

    .line 117
    :cond_1e
    const/4 p0, 0x0

    sput p0, Lradiant/KaraokeBridge;->vocalGain:F

    .line 119
    :goto_21
    return-void
.end method

.method private static ensureBound(Landroid/content/Context;)V
    .registers 9

    .line 163
    if-nez p0, :cond_3

    return-void

    .line 164
    :cond_3
    sget-object v0, Lradiant/KaraokeBridge;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 165
    :try_start_6
    sget-boolean v1, Lradiant/KaraokeBridge;->bound:Z

    if-eqz v1, :cond_18

    sget-object v1, Lradiant/KaraokeBridge;->serviceBinder:Landroid/os/IBinder;

    if-eqz v1, :cond_18

    sget-object v1, Lradiant/KaraokeBridge;->serviceBinder:Landroid/os/IBinder;

    invoke-interface {v1}, Landroid/os/IBinder;->isBinderAlive()Z

    move-result v1

    if-eqz v1, :cond_18

    .line 166
    monitor-exit v0

    return-void

    .line 168
    :cond_18
    sput-object p0, Lradiant/KaraokeBridge;->boundContext:Landroid/content/Context;
    :try_end_1a
    .catchall {:try_start_6 .. :try_end_1a} :catchall_a3

    .line 169
    nop

    .line 171
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

    .line 172
    sget-object v4, Lradiant/KaraokeBridge;->CONN:Landroid/content/ServiceConnection;

    invoke-virtual {p0, v3, v4, v1}, Landroid/content/Context;->bindService(Landroid/content/Intent;Landroid/content/ServiceConnection;I)Z

    move-result v3
    :try_end_35
    .catchall {:try_start_1d .. :try_end_35} :catchall_36

    .line 175
    goto :goto_54

    .line 173
    :catchall_36
    move-exception v3

    .line 174
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

    .line 176
    :goto_54
    if-nez v3, :cond_8c

    .line 178
    :try_start_56
    new-instance v4, Landroid/content/Intent;

    invoke-direct {v4}, Landroid/content/Intent;-><init>()V

    new-instance v5, Landroid/content/ComponentName;

    const-string v6, "com.meowarex.rlmobile"

    const-string v7, "com.meowarex.rlmobile.karaoke.KaraokeRelayService"

    invoke-direct {v5, v6, v7}, Landroid/content/ComponentName;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v4, v5}, Landroid/content/Intent;->setComponent(Landroid/content/ComponentName;)Landroid/content/Intent;

    move-result-object v4

    .line 179
    sget-object v5, Lradiant/KaraokeBridge;->CONN:Landroid/content/ServiceConnection;

    invoke-virtual {p0, v4, v5, v1}, Landroid/content/Context;->bindService(Landroid/content/Intent;Landroid/content/ServiceConnection;I)Z

    move-result v3
    :try_end_6e
    .catchall {:try_start_56 .. :try_end_6e} :catchall_6f

    .line 182
    goto :goto_8c

    .line 180
    :catchall_6f
    move-exception v1

    .line 181
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

    .line 184
    :cond_8c
    :goto_8c
    sput-boolean v3, Lradiant/KaraokeBridge;->bound:Z

    .line 185
    if-nez v3, :cond_a1

    .line 186
    const-string v1, "RLKaraokeBridge"

    const-string v3, "KaraokeRelayService not reachable; disabling"

    invoke-static {v1, v3}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 187
    sput-boolean v2, Lradiant/KaraokeBridge;->enabled:Z

    .line 188
    invoke-static {v2}, Lradiant/KaraokeButton;->syncState(Z)V

    .line 189
    const-string v1, "Install Radiant Manager QNN first"

    invoke-static {p0, v1}, Lradiant/KaraokeBridge;->toast(Landroid/content/Context;Ljava/lang/String;)V

    .line 191
    :cond_a1
    monitor-exit v0

    .line 192
    return-void

    .line 191
    :catchall_a3
    move-exception p0

    monitor-exit v0
    :try_end_a5
    .catchall {:try_start_70 .. :try_end_a5} :catchall_a3

    throw p0
.end method

.method public static getChunkFrames()I
    .registers 1

    .line 95
    sget v0, Lradiant/KaraokeBridge;->chunkFrames:I

    return v0
.end method

.method public static getLastMs()D
    .registers 2

    .line 91
    sget-wide v0, Lradiant/KaraokeBridge;->lastMs:D

    return-wide v0
.end method

.method public static getLastProvider()Ljava/lang/String;
    .registers 1

    .line 87
    sget-object v0, Lradiant/KaraokeBridge;->lastProvider:Ljava/lang/String;

    return-object v0
.end method

.method public static getMode()Ljava/lang/String;
    .registers 1

    .line 79
    sget-object v0, Lradiant/KaraokeBridge;->mode:Ljava/lang/String;

    return-object v0
.end method

.method public static getVocalGain()F
    .registers 1

    .line 83
    sget v0, Lradiant/KaraokeBridge;->vocalGain:F

    return v0
.end method

.method public static isEnabled()Z
    .registers 1

    .line 75
    sget-boolean v0, Lradiant/KaraokeBridge;->enabled:Z

    return v0
.end method

.method private static queryStatusAsync()V
    .registers 3

    .line 227
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lradiant/KaraokeBridge$3;

    invoke-direct {v1}, Lradiant/KaraokeBridge$3;-><init>()V

    const-string v2, "Karaoke-Status"

    invoke-direct {v0, v1, v2}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    .line 258
    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Ljava/lang/Thread;->setDaemon(Z)V

    .line 259
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    .line 260
    return-void
.end method

.method public static separateHop(Ljava/lang/String;[BII)[B
    .registers 5

    .line 268
    if-eqz p1, :cond_b

    if-gtz p3, :cond_5

    goto :goto_b

    .line 269
    :cond_5
    const/4 v0, 0x4

    invoke-static {v0, p0, p1, p2, p3}, Lradiant/KaraokeBridge;->separateInternal(ILjava/lang/String;[BII)[B

    move-result-object p0

    return-object p0

    .line 268
    :cond_b
    :goto_b
    return-object p1
.end method

.method private static separateInternal(ILjava/lang/String;[BII)[B
    .registers 16

    .line 273
    const-string v0, "RLKaraokeBridge"

    mul-int/lit8 v1, p4, 0x4

    .line 274
    sget-boolean v2, Lradiant/KaraokeBridge;->enabled:Z

    const/4 v3, 0x4

    if-eqz v2, :cond_135

    if-eqz p2, :cond_135

    array-length v2, p2

    if-ge v2, v3, :cond_10

    goto/16 :goto_135

    .line 277
    :cond_10
    const-wide/16 v4, 0xdac

    invoke-static {v4, v5}, Lradiant/KaraokeBridge;->awaitBinder(J)Landroid/os/IBinder;

    move-result-object v2

    .line 278
    if-nez v2, :cond_1e

    .line 279
    mul-int/2addr p3, v3

    invoke-static {p2, p3, v1}, Lradiant/KaraokeBridge;->sliceDryFallback([BII)[B

    move-result-object p0

    return-object p0

    .line 282
    :cond_1e
    nop

    .line 283
    nop

    .line 284
    invoke-static {}, Landroid/os/Parcel;->obtain()Landroid/os/Parcel;

    move-result-object v4

    .line 285
    invoke-static {}, Landroid/os/Parcel;->obtain()Landroid/os/Parcel;

    move-result-object v5

    .line 287
    const/4 v6, 0x0

    :try_start_29
    const-string v7, "rl_kara"

    array-length v8, p2

    invoke-static {v7, v8}, Landroid/os/SharedMemory;->create(Ljava/lang/String;I)Landroid/os/SharedMemory;

    move-result-object v7
    :try_end_30
    .catchall {:try_start_29 .. :try_end_30} :catchall_e9

    .line 288
    :try_start_30
    invoke-virtual {v7}, Landroid/os/SharedMemory;->mapReadWrite()Ljava/nio/ByteBuffer;

    move-result-object v6

    .line 289
    const/4 v8, 0x0

    invoke-virtual {v6, v8}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    move-result-object v9

    check-cast v9, Ljava/nio/ByteBuffer;

    .line 290
    array-length v9, p2

    invoke-virtual {v6, p2, v8, v9}, Ljava/nio/ByteBuffer;->put([BII)Ljava/nio/ByteBuffer;

    .line 292
    const-string v9, "radiant.karaoke.IRelay"

    invoke-virtual {v4, v9}, Landroid/os/Parcel;->writeInterfaceToken(Ljava/lang/String;)V

    .line 293
    invoke-virtual {v4, p1}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 294
    array-length p1, p2

    invoke-virtual {v4, p1}, Landroid/os/Parcel;->writeInt(I)V

    .line 295
    if-ne p0, v3, :cond_53

    .line 296
    invoke-virtual {v4, p3}, Landroid/os/Parcel;->writeInt(I)V

    .line 297
    invoke-virtual {v4, p4}, Landroid/os/Parcel;->writeInt(I)V

    .line 299
    :cond_53
    invoke-virtual {v7, v4, v8}, Landroid/os/SharedMemory;->writeToParcel(Landroid/os/Parcel;I)V

    .line 301
    invoke-interface {v2, p0, v4, v5, v8}, Landroid/os/IBinder;->transact(ILandroid/os/Parcel;Landroid/os/Parcel;I)Z

    move-result p0

    .line 302
    if-nez p0, :cond_77

    .line 303
    mul-int/lit8 p0, p3, 0x4

    invoke-static {p2, p0, v1}, Lradiant/KaraokeBridge;->sliceDryFallback([BII)[B

    move-result-object p0
    :try_end_62
    .catchall {:try_start_30 .. :try_end_62} :catchall_e5

    .line 325
    if-eqz v6, :cond_69

    .line 326
    :try_start_64
    invoke-static {v6}, Landroid/os/SharedMemory;->unmap(Ljava/nio/ByteBuffer;)V
    :try_end_67
    .catchall {:try_start_64 .. :try_end_67} :catchall_68

    goto :goto_69

    :catchall_68
    move-exception p1

    .line 328
    :cond_69
    :goto_69
    if-eqz v7, :cond_70

    .line 329
    :try_start_6b
    invoke-virtual {v7}, Landroid/os/SharedMemory;->close()V
    :try_end_6e
    .catchall {:try_start_6b .. :try_end_6e} :catchall_6f

    goto :goto_70

    :catchall_6f
    move-exception p1

    .line 331
    :cond_70
    :goto_70
    invoke-virtual {v4}, Landroid/os/Parcel;->recycle()V

    .line 332
    invoke-virtual {v5}, Landroid/os/Parcel;->recycle()V

    .line 303
    return-object p0

    .line 305
    :cond_77
    :try_start_77
    invoke-virtual {v5}, Landroid/os/Parcel;->readException()V

    .line 306
    invoke-virtual {v5}, Landroid/os/Parcel;->readInt()I

    move-result p0

    .line 307
    const/4 p1, 0x1

    if-eq p0, p1, :cond_b6

    .line 308
    invoke-virtual {v5}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object p0

    .line 309
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p4, "Relay returned failure: "

    invoke-virtual {p1, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 310
    mul-int/lit8 p0, p3, 0x4

    invoke-static {p2, p0, v1}, Lradiant/KaraokeBridge;->sliceDryFallback([BII)[B

    move-result-object p0
    :try_end_a1
    .catchall {:try_start_77 .. :try_end_a1} :catchall_e5

    .line 325
    if-eqz v6, :cond_a8

    .line 326
    :try_start_a3
    invoke-static {v6}, Landroid/os/SharedMemory;->unmap(Ljava/nio/ByteBuffer;)V
    :try_end_a6
    .catchall {:try_start_a3 .. :try_end_a6} :catchall_a7

    goto :goto_a8

    :catchall_a7
    move-exception p1

    .line 328
    :cond_a8
    :goto_a8
    if-eqz v7, :cond_af

    .line 329
    :try_start_aa
    invoke-virtual {v7}, Landroid/os/SharedMemory;->close()V
    :try_end_ad
    .catchall {:try_start_aa .. :try_end_ad} :catchall_ae

    goto :goto_af

    :catchall_ae
    move-exception p1

    .line 331
    :cond_af
    :goto_af
    invoke-virtual {v4}, Landroid/os/Parcel;->recycle()V

    .line 332
    invoke-virtual {v5}, Landroid/os/Parcel;->recycle()V

    .line 310
    return-object p0

    .line 312
    :cond_b6
    :try_start_b6
    invoke-virtual {v5}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object p0

    .line 313
    invoke-virtual {v5}, Landroid/os/Parcel;->readDouble()D

    move-result-wide v9

    .line 314
    if-eqz p0, :cond_c2

    sput-object p0, Lradiant/KaraokeBridge;->lastProvider:Ljava/lang/String;

    .line 315
    :cond_c2
    sput-wide v9, Lradiant/KaraokeBridge;->lastMs:D

    .line 317
    new-array p0, v1, [B

    .line 318
    invoke-virtual {v6, v8}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    move-result-object p1

    check-cast p1, Ljava/nio/ByteBuffer;

    .line 319
    invoke-virtual {v6, p0, v8, v1}, Ljava/nio/ByteBuffer;->get([BII)Ljava/nio/ByteBuffer;
    :try_end_cf
    .catchall {:try_start_b6 .. :try_end_cf} :catchall_e5

    .line 320
    nop

    .line 325
    if-eqz v6, :cond_d7

    .line 326
    :try_start_d2
    invoke-static {v6}, Landroid/os/SharedMemory;->unmap(Ljava/nio/ByteBuffer;)V
    :try_end_d5
    .catchall {:try_start_d2 .. :try_end_d5} :catchall_d6

    goto :goto_d7

    :catchall_d6
    move-exception p1

    .line 328
    :cond_d7
    :goto_d7
    if-eqz v7, :cond_de

    .line 329
    :try_start_d9
    invoke-virtual {v7}, Landroid/os/SharedMemory;->close()V
    :try_end_dc
    .catchall {:try_start_d9 .. :try_end_dc} :catchall_dd

    goto :goto_de

    :catchall_dd
    move-exception p1

    .line 331
    :cond_de
    :goto_de
    invoke-virtual {v4}, Landroid/os/Parcel;->recycle()V

    .line 332
    invoke-virtual {v5}, Landroid/os/Parcel;->recycle()V

    .line 320
    return-object p0

    .line 321
    :catchall_e5
    move-exception p0

    move-object p1, v6

    move-object v6, v7

    goto :goto_eb

    :catchall_e9
    move-exception p0

    move-object p1, v6

    .line 322
    :goto_eb
    :try_start_eb
    invoke-virtual {p0}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object p0

    new-instance p4, Ljava/lang/StringBuilder;

    invoke-direct {p4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "separate Binder error: "

    invoke-virtual {p4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p4

    invoke-virtual {p4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 323
    mul-int/2addr p3, v3

    invoke-static {p2, p3, v1}, Lradiant/KaraokeBridge;->sliceDryFallback([BII)[B

    move-result-object p0
    :try_end_10a
    .catchall {:try_start_eb .. :try_end_10a} :catchall_11f

    .line 325
    if-eqz p1, :cond_111

    .line 326
    :try_start_10c
    invoke-static {p1}, Landroid/os/SharedMemory;->unmap(Ljava/nio/ByteBuffer;)V
    :try_end_10f
    .catchall {:try_start_10c .. :try_end_10f} :catchall_110

    goto :goto_111

    :catchall_110
    move-exception p1

    .line 328
    :cond_111
    :goto_111
    if-eqz v6, :cond_118

    .line 329
    :try_start_113
    invoke-virtual {v6}, Landroid/os/SharedMemory;->close()V
    :try_end_116
    .catchall {:try_start_113 .. :try_end_116} :catchall_117

    goto :goto_118

    :catchall_117
    move-exception p1

    .line 331
    :cond_118
    :goto_118
    invoke-virtual {v4}, Landroid/os/Parcel;->recycle()V

    .line 332
    invoke-virtual {v5}, Landroid/os/Parcel;->recycle()V

    .line 323
    return-object p0

    .line 325
    :catchall_11f
    move-exception p0

    if-eqz p1, :cond_127

    .line 326
    :try_start_122
    invoke-static {p1}, Landroid/os/SharedMemory;->unmap(Ljava/nio/ByteBuffer;)V
    :try_end_125
    .catchall {:try_start_122 .. :try_end_125} :catchall_126

    goto :goto_127

    :catchall_126
    move-exception p1

    .line 328
    :cond_127
    :goto_127
    if-eqz v6, :cond_12e

    .line 329
    :try_start_129
    invoke-virtual {v6}, Landroid/os/SharedMemory;->close()V
    :try_end_12c
    .catchall {:try_start_129 .. :try_end_12c} :catchall_12d

    goto :goto_12e

    :catchall_12d
    move-exception p1

    .line 331
    :cond_12e
    :goto_12e
    invoke-virtual {v4}, Landroid/os/Parcel;->recycle()V

    .line 332
    invoke-virtual {v5}, Landroid/os/Parcel;->recycle()V

    .line 333
    throw p0

    .line 275
    :cond_135
    :goto_135
    mul-int/2addr p3, v3

    invoke-static {p2, p3, v1}, Lradiant/KaraokeBridge;->sliceDryFallback([BII)[B

    move-result-object p0

    return-object p0
.end method

.method public static separatePcm(Ljava/lang/String;[B)[B
    .registers 5

    .line 263
    if-eqz p1, :cond_10

    array-length v0, p1

    const/4 v1, 0x4

    if-ge v0, v1, :cond_7

    goto :goto_10

    .line 264
    :cond_7
    array-length v0, p1

    div-int/2addr v0, v1

    const/4 v1, 0x2

    const/4 v2, 0x0

    invoke-static {v1, p0, p1, v2, v0}, Lradiant/KaraokeBridge;->separateInternal(ILjava/lang/String;[BII)[B

    move-result-object p0

    return-object p0

    .line 263
    :cond_10
    :goto_10
    return-object p1
.end method

.method public static setEnabled(Landroid/content/Context;Z)V
    .registers 4

    .line 126
    if-eqz p0, :cond_7

    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    goto :goto_b

    :cond_7
    invoke-static {}, Lradiant/KaraokeBridge;->appContext()Landroid/content/Context;

    move-result-object p0

    .line 127
    :goto_b
    sput-boolean p1, Lradiant/KaraokeBridge;->enabled:Z

    .line 128
    invoke-static {p1}, Lradiant/KaraokeButton;->syncState(Z)V

    .line 130
    if-eqz p1, :cond_41

    .line 131
    invoke-static {p0}, Lradiant/KaraokeBridge;->ensureBound(Landroid/content/Context;)V

    .line 132
    const-string p1, "instrumental"

    sget-object v0, Lradiant/KaraokeBridge;->mode:Ljava/lang/String;

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_22

    const-string p1, "Inst_HQ_3"

    goto :goto_24

    :cond_22
    const-string p1, "KARA_2"

    .line 133
    :goto_24
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

    .line 134
    goto :goto_4d

    .line 135
    :cond_41
    invoke-static {}, Lradiant/KaraokeBridge;->unbindAndUnload()V

    .line 136
    const-string p1, "Idle"

    sput-object p1, Lradiant/KaraokeBridge;->lastProvider:Ljava/lang/String;

    .line 137
    const-string p1, "Karaoke NPU: OFF"

    invoke-static {p0, p1}, Lradiant/KaraokeBridge;->toast(Landroid/content/Context;Ljava/lang/String;)V

    .line 139
    :goto_4d
    return-void
.end method

.method public static setMode(Landroid/content/Context;Ljava/lang/String;)V
    .registers 4

    .line 99
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

    .line 100
    sget-boolean p1, Lradiant/KaraokeBridge;->enabled:Z

    if-eqz p1, :cond_37

    if-eqz p0, :cond_37

    .line 101
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

    .line 103
    :cond_37
    return-void
.end method

.method public static setVocalGain(Landroid/content/Context;F)V
    .registers 3

    .line 106
    const/4 p0, 0x0

    cmpg-float v0, p1, p0

    if-gez v0, :cond_6

    move p1, p0

    .line 107
    :cond_6
    const/high16 p0, 0x3f800000    # 1.0f

    cmpl-float v0, p1, p0

    if-lez v0, :cond_d

    move p1, p0

    .line 108
    :cond_d
    sput p1, Lradiant/KaraokeBridge;->vocalGain:F

    .line 109
    return-void
.end method

.method private static sliceDryFallback([BII)[B
    .registers 5

    .line 337
    if-nez p0, :cond_4

    const/4 p0, 0x0

    return-object p0

    .line 338
    :cond_4
    if-nez p1, :cond_a

    array-length v0, p0

    if-ne p2, v0, :cond_a

    return-object p0

    .line 339
    :cond_a
    new-array v0, p2, [B

    .line 340
    if-ltz p1, :cond_1b

    array-length v1, p0

    if-ge p1, v1, :cond_1b

    .line 341
    array-length v1, p0

    sub-int/2addr v1, p1

    invoke-static {p2, v1}, Ljava/lang/Math;->min(II)I

    move-result p2

    const/4 v1, 0x0

    invoke-static {p0, p1, v0, v1, p2}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 343
    :cond_1b
    return-object v0
.end method

.method private static toast(Landroid/content/Context;Ljava/lang/String;)V
    .registers 4

    .line 142
    if-nez p0, :cond_3

    return-void

    .line 143
    :cond_3
    sget-object v0, Lradiant/KaraokeBridge;->MAIN:Landroid/os/Handler;

    new-instance v1, Lradiant/KaraokeBridge$2;

    invoke-direct {v1, p0, p1}, Lradiant/KaraokeBridge$2;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 151
    return-void
.end method

.method public static toggle(Landroid/content/Context;)V
    .registers 2

    .line 122
    sget-boolean v0, Lradiant/KaraokeBridge;->enabled:Z

    xor-int/lit8 v0, v0, 0x1

    invoke-static {p0, v0}, Lradiant/KaraokeBridge;->setEnabled(Landroid/content/Context;Z)V

    .line 123
    return-void
.end method

.method private static unbindAndUnload()V
    .registers 7

    .line 198
    sget-object v0, Lradiant/KaraokeBridge;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 199
    :try_start_3
    sget-object v1, Lradiant/KaraokeBridge;->serviceBinder:Landroid/os/IBinder;

    .line 200
    sget-object v2, Lradiant/KaraokeBridge;->boundContext:Landroid/content/Context;

    .line 201
    sget-boolean v3, Lradiant/KaraokeBridge;->bound:Z

    .line 202
    const/4 v4, 0x0

    sput-object v4, Lradiant/KaraokeBridge;->serviceBinder:Landroid/os/IBinder;

    .line 203
    const/4 v5, 0x0

    sput-boolean v5, Lradiant/KaraokeBridge;->bound:Z

    .line 204
    sput-object v4, Lradiant/KaraokeBridge;->boundContext:Landroid/content/Context;

    .line 205
    monitor-exit v0
    :try_end_12
    .catchall {:try_start_3 .. :try_end_12} :catchall_3e

    .line 206
    if-eqz v1, :cond_31

    .line 207
    invoke-static {}, Landroid/os/Parcel;->obtain()Landroid/os/Parcel;

    move-result-object v0

    .line 208
    invoke-static {}, Landroid/os/Parcel;->obtain()Landroid/os/Parcel;

    move-result-object v4

    .line 210
    :try_start_1c
    const-string v6, "radiant.karaoke.IRelay"

    invoke-virtual {v0, v6}, Landroid/os/Parcel;->writeInterfaceToken(Ljava/lang/String;)V

    .line 211
    const/4 v6, 0x3

    invoke-interface {v1, v6, v0, v4, v5}, Landroid/os/IBinder;->transact(ILandroid/os/Parcel;Landroid/os/Parcel;I)Z

    .line 212
    invoke-virtual {v4}, Landroid/os/Parcel;->readException()V
    :try_end_28
    .catchall {:try_start_1c .. :try_end_28} :catchall_29

    goto :goto_2a

    .line 213
    :catchall_29
    move-exception v1

    .line 215
    :goto_2a
    invoke-virtual {v0}, Landroid/os/Parcel;->recycle()V

    .line 216
    invoke-virtual {v4}, Landroid/os/Parcel;->recycle()V

    .line 217
    nop

    .line 219
    :cond_31
    if-eqz v3, :cond_3d

    if-eqz v2, :cond_3d

    .line 221
    :try_start_35
    sget-object v0, Lradiant/KaraokeBridge;->CONN:Landroid/content/ServiceConnection;

    invoke-virtual {v2, v0}, Landroid/content/Context;->unbindService(Landroid/content/ServiceConnection;)V
    :try_end_3a
    .catchall {:try_start_35 .. :try_end_3a} :catchall_3b

    goto :goto_3c

    .line 222
    :catchall_3b
    move-exception v0

    :goto_3c
    nop

    .line 224
    :cond_3d
    return-void

    .line 205
    :catchall_3e
    move-exception v1

    :try_start_3f
    monitor-exit v0
    :try_end_40
    .catchall {:try_start_3f .. :try_end_40} :catchall_3e

    throw v1
.end method

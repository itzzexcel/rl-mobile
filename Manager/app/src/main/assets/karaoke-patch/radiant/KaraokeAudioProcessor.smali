.class public final Lradiant/KaraokeAudioProcessor;
.super Landroidx/media3/common/audio/BaseAudioProcessor;
.source "KaraokeAudioProcessor.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lradiant/KaraokeAudioProcessor$ReadyChunk;,
        Lradiant/KaraokeAudioProcessor$PendingChunk;
    }
.end annotation


# static fields
.field private static final DISPATCH_OUT_START:I = 0x39200

.field private static final DISPATCH_SLICE_BYTES:I = 0x18800

.field private static final DISPATCH_SLICE_FRAMES:I = 0x6200

.field private static final ENCODING_PCM_16BIT:I = 0x2

.field private static final ENCODING_PCM_24BIT_LEGACY:I = 0x20000000

.field private static final ENCODING_PCM_24BIT_MEDIA3:I = 0x15

.field private static final ENCODING_PCM_32BIT_LEGACY:I = 0x30000000

.field private static final ENCODING_PCM_32BIT_MEDIA3:I = 0x16

.field private static final ENCODING_PCM_FLOAT:I = 0x4

.field private static final HOP_BYTES:I = 0x18000

.field private static final HOP_FRAMES:I = 0x6000

.field private static final LOOKAHEAD_FRAMES:I = 0x800

.field private static final MAX_BUFFERED_HOPS:I = 0x3

.field private static final TAG:Ljava/lang/String; = "RLKaraokeAudio"

.field private static final TOGGLE_XFADE_FRAMES:I = 0x52b

.field private static final WAIT_READY_TIMEOUT_MS:J = 0x708L

.field private static final WINDOW_BYTES:I = 0xff000

.field private static final WINDOW_FRAMES:I = 0x3fc00

.field private static final XFADE_BYTES:I = 0x800

.field private static final XFADE_FRAMES:I = 0x200


# instance fields
.field private activeOut:Lradiant/KaraokeAudioProcessor$ReadyChunk;

.field private activeOutOffset:I

.field private drainScratch:[B

.field private dryHistory:[B

.field private fadeInFramesDone:I

.field private volatile generation:I

.field private mixSliceScratch:[B

.field private nextDispatchStartFrame:J

.field private final pendingQueue:Ljava/util/LinkedList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/LinkedList<",
            "Lradiant/KaraokeAudioProcessor$PendingChunk;",
            ">;"
        }
    .end annotation
.end field

.field private primed:Z

.field private final queueLock:Ljava/lang/Object;

.field private final readyQueue:Ljava/util/LinkedList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/LinkedList<",
            "Lradiant/KaraokeAudioProcessor$ReadyChunk;",
            ">;"
        }
    .end annotation
.end field

.field private scratchPcm16:[B

.field private totalFramesIn:J

.field private totalFramesOut:J

.field private wasEnabled:Z

.field private workerBusy:Z

.field private workerPrevTail:[B

.field private workerPrevTailGen:I

.field private workerStarted:Z


# direct methods
.method static bridge synthetic -$$Nest$fgetgeneration(Lradiant/KaraokeAudioProcessor;)I
    .registers 1

    iget p0, p0, Lradiant/KaraokeAudioProcessor;->generation:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetpendingQueue(Lradiant/KaraokeAudioProcessor;)Ljava/util/LinkedList;
    .registers 1

    iget-object p0, p0, Lradiant/KaraokeAudioProcessor;->pendingQueue:Ljava/util/LinkedList;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetqueueLock(Lradiant/KaraokeAudioProcessor;)Ljava/lang/Object;
    .registers 1

    iget-object p0, p0, Lradiant/KaraokeAudioProcessor;->queueLock:Ljava/lang/Object;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetreadyQueue(Lradiant/KaraokeAudioProcessor;)Ljava/util/LinkedList;
    .registers 1

    iget-object p0, p0, Lradiant/KaraokeAudioProcessor;->readyQueue:Ljava/util/LinkedList;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetworkerPrevTail(Lradiant/KaraokeAudioProcessor;)[B
    .registers 1

    iget-object p0, p0, Lradiant/KaraokeAudioProcessor;->workerPrevTail:[B

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetworkerPrevTailGen(Lradiant/KaraokeAudioProcessor;)I
    .registers 1

    iget p0, p0, Lradiant/KaraokeAudioProcessor;->workerPrevTailGen:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fputworkerBusy(Lradiant/KaraokeAudioProcessor;Z)V
    .registers 2

    iput-boolean p1, p0, Lradiant/KaraokeAudioProcessor;->workerBusy:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$fputworkerPrevTailGen(Lradiant/KaraokeAudioProcessor;I)V
    .registers 2

    iput p1, p0, Lradiant/KaraokeAudioProcessor;->workerPrevTailGen:I

    return-void
.end method

.method static bridge synthetic -$$Nest$smcrossfadeInPlace([B[BI)V
    .registers 3

    invoke-static {p0, p1, p2}, Lradiant/KaraokeAudioProcessor;->crossfadeInPlace([B[BI)V

    return-void
.end method

.method public constructor <init>()V
    .registers 5

    .line 93
    invoke-direct {p0}, Landroidx/media3/common/audio/BaseAudioProcessor;-><init>()V

    .line 68
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    iput-object v0, p0, Lradiant/KaraokeAudioProcessor;->queueLock:Ljava/lang/Object;

    .line 69
    new-instance v0, Ljava/util/LinkedList;

    invoke-direct {v0}, Ljava/util/LinkedList;-><init>()V

    iput-object v0, p0, Lradiant/KaraokeAudioProcessor;->pendingQueue:Ljava/util/LinkedList;

    .line 70
    new-instance v0, Ljava/util/LinkedList;

    invoke-direct {v0}, Ljava/util/LinkedList;-><init>()V

    iput-object v0, p0, Lradiant/KaraokeAudioProcessor;->readyQueue:Ljava/util/LinkedList;

    .line 71
    const/4 v0, 0x0

    iput v0, p0, Lradiant/KaraokeAudioProcessor;->generation:I

    .line 73
    iput-boolean v0, p0, Lradiant/KaraokeAudioProcessor;->workerStarted:Z

    .line 74
    iput-boolean v0, p0, Lradiant/KaraokeAudioProcessor;->workerBusy:Z

    .line 75
    const/16 v1, 0x800

    new-array v1, v1, [B

    iput-object v1, p0, Lradiant/KaraokeAudioProcessor;->workerPrevTail:[B

    .line 76
    const/4 v1, -0x1

    iput v1, p0, Lradiant/KaraokeAudioProcessor;->workerPrevTailGen:I

    .line 78
    const/4 v1, 0x0

    iput-object v1, p0, Lradiant/KaraokeAudioProcessor;->dryHistory:[B

    .line 79
    const-wide/16 v2, 0x0

    iput-wide v2, p0, Lradiant/KaraokeAudioProcessor;->totalFramesIn:J

    .line 80
    iput-wide v2, p0, Lradiant/KaraokeAudioProcessor;->totalFramesOut:J

    .line 81
    iput-wide v2, p0, Lradiant/KaraokeAudioProcessor;->nextDispatchStartFrame:J

    .line 83
    const/16 v2, 0x4000

    new-array v2, v2, [B

    iput-object v2, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    .line 84
    const v2, 0x8000

    new-array v2, v2, [B

    iput-object v2, p0, Lradiant/KaraokeAudioProcessor;->mixSliceScratch:[B

    .line 85
    iput-object v1, p0, Lradiant/KaraokeAudioProcessor;->drainScratch:[B

    .line 87
    iput-boolean v0, p0, Lradiant/KaraokeAudioProcessor;->primed:Z

    .line 88
    iput-boolean v0, p0, Lradiant/KaraokeAudioProcessor;->wasEnabled:Z

    .line 89
    const/16 v2, 0x52b

    iput v2, p0, Lradiant/KaraokeAudioProcessor;->fadeInFramesDone:I

    .line 90
    iput-object v1, p0, Lradiant/KaraokeAudioProcessor;->activeOut:Lradiant/KaraokeAudioProcessor$ReadyChunk;

    .line 91
    iput v0, p0, Lradiant/KaraokeAudioProcessor;->activeOutOffset:I

    .line 95
    return-void
.end method

.method private appendBlendedSlice(Ljava/nio/ByteBuffer;[B[BIIF)V
    .registers 16

    .line 448
    iget v0, p0, Lradiant/KaraokeAudioProcessor;->fadeInFramesDone:I

    const/16 v1, 0x52b

    if-lt v0, v1, :cond_23

    .line 449
    if-eqz p3, :cond_1f

    array-length v0, p3

    array-length v2, p2

    if-ne v0, v2, :cond_1f

    const v0, 0x3f7fbe77    # 0.999f

    cmpl-float v0, p6, v0

    if-ltz v0, :cond_14

    goto :goto_1f

    .line 453
    :cond_14
    const v0, 0x3a83126f    # 0.001f

    cmpg-float v0, p6, v0

    if-gtz v0, :cond_23

    .line 454
    invoke-virtual {p1, p3, p4, p5}, Ljava/nio/ByteBuffer;->put([BII)Ljava/nio/ByteBuffer;

    .line 455
    return-void

    .line 450
    :cond_1f
    :goto_1f
    invoke-virtual {p1, p2, p4, p5}, Ljava/nio/ByteBuffer;->put([BII)Ljava/nio/ByteBuffer;

    .line 451
    return-void

    .line 458
    :cond_23
    invoke-direct {p0, p5}, Lradiant/KaraokeAudioProcessor;->ensureMixScratchCapacity(I)V

    .line 459
    div-int/lit8 v0, p5, 0x4

    .line 460
    const/4 v2, 0x0

    move v3, v2

    :goto_2a
    if-ge v3, v0, :cond_92

    .line 461
    mul-int/lit8 v4, v3, 0x4

    .line 462
    add-int v5, p4, v4

    .line 463
    nop

    .line 464
    iget v6, p0, Lradiant/KaraokeAudioProcessor;->fadeInFramesDone:I

    if-ge v6, v1, :cond_4c

    .line 465
    iget v6, p0, Lradiant/KaraokeAudioProcessor;->fadeInFramesDone:I

    int-to-float v6, v6

    const/high16 v7, 0x3f000000    # 0.5f

    add-float/2addr v6, v7

    const v7, 0x44a56000    # 1323.0f

    div-float/2addr v6, v7

    .line 466
    iget v7, p0, Lradiant/KaraokeAudioProcessor;->fadeInFramesDone:I

    add-int/lit8 v7, v7, 0x1

    iput v7, p0, Lradiant/KaraokeAudioProcessor;->fadeInFramesDone:I

    .line 467
    const/high16 v7, 0x3f800000    # 1.0f

    sub-float v8, v7, p6

    mul-float/2addr v6, v8

    sub-float/2addr v7, v6

    goto :goto_4d

    .line 464
    :cond_4c
    move v7, p6

    .line 469
    :goto_4d
    invoke-static {p2, p3, v5, v7}, Lradiant/KaraokeAudioProcessor;->wetSampleAt([B[BIF)I

    move-result v6

    .line 470
    add-int/lit8 v5, v5, 0x2

    invoke-static {p2, p3, v5, v7}, Lradiant/KaraokeAudioProcessor;->wetSampleAt([B[BIF)I

    move-result v5

    .line 471
    const/16 v7, 0x7fff

    const/16 v8, -0x8000

    if-ge v6, v8, :cond_5f

    move v6, v8

    goto :goto_62

    :cond_5f
    if-le v6, v7, :cond_62

    move v6, v7

    .line 472
    :cond_62
    :goto_62
    if-ge v5, v8, :cond_66

    move v5, v8

    goto :goto_69

    :cond_66
    if-le v5, v7, :cond_69

    move v5, v7

    .line 473
    :cond_69
    :goto_69
    iget-object v7, p0, Lradiant/KaraokeAudioProcessor;->mixSliceScratch:[B

    and-int/lit16 v8, v6, 0xff

    int-to-byte v8, v8

    aput-byte v8, v7, v4

    .line 474
    iget-object v7, p0, Lradiant/KaraokeAudioProcessor;->mixSliceScratch:[B

    add-int/lit8 v8, v4, 0x1

    shr-int/lit8 v6, v6, 0x8

    and-int/lit16 v6, v6, 0xff

    int-to-byte v6, v6

    aput-byte v6, v7, v8

    .line 475
    iget-object v6, p0, Lradiant/KaraokeAudioProcessor;->mixSliceScratch:[B

    add-int/lit8 v7, v4, 0x2

    and-int/lit16 v8, v5, 0xff

    int-to-byte v8, v8

    aput-byte v8, v6, v7

    .line 476
    iget-object v6, p0, Lradiant/KaraokeAudioProcessor;->mixSliceScratch:[B

    add-int/lit8 v4, v4, 0x3

    shr-int/lit8 v5, v5, 0x8

    and-int/lit16 v5, v5, 0xff

    int-to-byte v5, v5

    aput-byte v5, v6, v4

    .line 460
    add-int/lit8 v3, v3, 0x1

    goto :goto_2a

    .line 478
    :cond_92
    iget-object p2, p0, Lradiant/KaraokeAudioProcessor;->mixSliceScratch:[B

    invoke-virtual {p1, p2, v2, p5}, Ljava/nio/ByteBuffer;->put([BII)Ljava/nio/ByteBuffer;

    .line 479
    return-void
.end method

.method private appendToHistory([BII)V
    .registers 10

    .line 528
    if-gtz p3, :cond_3

    return-void

    .line 529
    :cond_3
    iget-object v0, p0, Lradiant/KaraokeAudioProcessor;->dryHistory:[B

    const v1, 0xff000

    if-nez v0, :cond_e

    .line 530
    new-array v0, v1, [B

    iput-object v0, p0, Lradiant/KaraokeAudioProcessor;->dryHistory:[B

    .line 532
    :cond_e
    nop

    .line 533
    nop

    .line 534
    if-lt p3, v1, :cond_16

    .line 535
    sub-int/2addr p3, v1

    add-int/2addr p3, p2

    .line 536
    move v0, v1

    goto :goto_18

    .line 534
    :cond_16
    move v0, p3

    move p3, p2

    .line 538
    :goto_18
    iget-wide v2, p0, Lradiant/KaraokeAudioProcessor;->totalFramesIn:J

    const-wide/16 v4, 0x4

    mul-long/2addr v2, v4

    sub-int p2, p3, p2

    int-to-long v4, p2

    add-long/2addr v2, v4

    .line 539
    const-wide/32 v4, 0xff000

    rem-long/2addr v2, v4

    long-to-int p2, v2

    .line 540
    sub-int/2addr v1, p2

    invoke-static {v0, v1}, Ljava/lang/Math;->min(II)I

    move-result v1

    .line 541
    iget-object v2, p0, Lradiant/KaraokeAudioProcessor;->dryHistory:[B

    invoke-static {p1, p3, v2, p2, v1}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 542
    if-ge v1, v0, :cond_3a

    .line 543
    add-int/2addr p3, v1

    iget-object p2, p0, Lradiant/KaraokeAudioProcessor;->dryHistory:[B

    const/4 v2, 0x0

    sub-int/2addr v0, v1

    invoke-static {p1, p3, p2, v2, v0}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 545
    :cond_3a
    return-void
.end method

.method private awaitNextReadyChunk(J)Lradiant/KaraokeAudioProcessor$ReadyChunk;
    .registers 11

    .line 369
    iget v0, p0, Lradiant/KaraokeAudioProcessor;->generation:I

    .line 370
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v1

    add-long/2addr v1, p1

    .line 371
    iget-object p1, p0, Lradiant/KaraokeAudioProcessor;->queueLock:Ljava/lang/Object;

    monitor-enter p1

    .line 372
    :goto_a
    :try_start_a
    iget p2, p0, Lradiant/KaraokeAudioProcessor;->generation:I

    const/4 v3, 0x0

    if-ne p2, v0, :cond_53

    .line 373
    :goto_f
    iget-object p2, p0, Lradiant/KaraokeAudioProcessor;->readyQueue:Ljava/util/LinkedList;

    invoke-virtual {p2}, Ljava/util/LinkedList;->isEmpty()Z

    move-result p2

    if-nez p2, :cond_2d

    .line 374
    iget-object p2, p0, Lradiant/KaraokeAudioProcessor;->readyQueue:Ljava/util/LinkedList;

    invoke-virtual {p2}, Ljava/util/LinkedList;->pollFirst()Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lradiant/KaraokeAudioProcessor$ReadyChunk;

    .line 375
    if-eqz p2, :cond_2c

    iget v4, p2, Lradiant/KaraokeAudioProcessor$ReadyChunk;->generation:I

    if-ne v4, v0, :cond_2c

    .line 376
    iget-object v0, p0, Lradiant/KaraokeAudioProcessor;->queueLock:Ljava/lang/Object;

    invoke-virtual {v0}, Ljava/lang/Object;->notifyAll()V

    .line 377
    monitor-exit p1

    return-object p2

    .line 379
    :cond_2c
    goto :goto_f

    .line 380
    :cond_2d
    invoke-static {}, Lradiant/KaraokeBridge;->isEnabled()Z

    move-result p2

    if-nez p2, :cond_35

    .line 381
    monitor-exit p1

    return-object v3

    .line 383
    :cond_35
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v4

    sub-long v4, v1, v4

    .line 384
    const-wide/16 v6, 0x0

    cmp-long p2, v4, v6

    if-gtz p2, :cond_43

    .line 385
    monitor-exit p1
    :try_end_42
    .catchall {:try_start_a .. :try_end_42} :catchall_55

    return-object v3

    .line 388
    :cond_43
    :try_start_43
    iget-object p2, p0, Lradiant/KaraokeAudioProcessor;->queueLock:Ljava/lang/Object;

    const-wide/16 v6, 0x14

    invoke-static {v6, v7, v4, v5}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v4

    invoke-virtual {p2, v4, v5}, Ljava/lang/Object;->wait(J)V
    :try_end_4e
    .catch Ljava/lang/InterruptedException; {:try_start_43 .. :try_end_4e} :catch_50
    .catchall {:try_start_43 .. :try_end_4e} :catchall_55

    .line 391
    nop

    .line 392
    goto :goto_a

    .line 389
    :catch_50
    move-exception p2

    .line 390
    :try_start_51
    monitor-exit p1

    return-object v3

    .line 393
    :cond_53
    monitor-exit p1

    return-object v3

    .line 394
    :catchall_55
    move-exception p2

    monitor-exit p1
    :try_end_57
    .catchall {:try_start_51 .. :try_end_57} :catchall_55

    throw p2
.end method

.method private static blendStereoSample([BI[BIFF[BI)V
    .registers 11

    .line 171
    aget-byte v0, p0, p1

    and-int/lit16 v0, v0, 0xff

    add-int/lit8 v1, p1, 0x1

    aget-byte v1, p0, v1

    shl-int/lit8 v1, v1, 0x8

    or-int/2addr v0, v1

    .line 172
    aget-byte v1, p2, p3

    and-int/lit16 v1, v1, 0xff

    add-int/lit8 v2, p3, 0x1

    aget-byte v2, p2, v2

    shl-int/lit8 v2, v2, 0x8

    or-int/2addr v1, v2

    .line 173
    add-int/lit8 v2, p1, 0x2

    aget-byte v2, p0, v2

    and-int/lit16 v2, v2, 0xff

    add-int/lit8 p1, p1, 0x3

    aget-byte p0, p0, p1

    shl-int/lit8 p0, p0, 0x8

    or-int/2addr p0, v2

    .line 174
    add-int/lit8 p1, p3, 0x2

    aget-byte p1, p2, p1

    and-int/lit16 p1, p1, 0xff

    add-int/lit8 p3, p3, 0x3

    aget-byte p2, p2, p3

    shl-int/lit8 p2, p2, 0x8

    or-int/2addr p1, p2

    .line 175
    int-to-float p2, v0

    mul-float/2addr p2, p4

    int-to-float p3, v1

    mul-float/2addr p3, p5

    add-float/2addr p2, p3

    invoke-static {p2}, Ljava/lang/Math;->round(F)I

    move-result p2

    .line 176
    int-to-float p0, p0

    mul-float/2addr p0, p4

    int-to-float p1, p1

    mul-float/2addr p1, p5

    add-float/2addr p0, p1

    invoke-static {p0}, Ljava/lang/Math;->round(F)I

    move-result p0

    .line 177
    const/16 p1, 0x7fff

    const/16 p3, -0x8000

    if-ge p2, p3, :cond_4a

    move p2, p3

    goto :goto_4d

    :cond_4a
    if-le p2, p1, :cond_4d

    move p2, p1

    .line 178
    :cond_4d
    :goto_4d
    if-ge p0, p3, :cond_51

    move p0, p3

    goto :goto_54

    :cond_51
    if-le p0, p1, :cond_54

    move p0, p1

    .line 179
    :cond_54
    :goto_54
    and-int/lit16 p1, p2, 0xff

    int-to-byte p1, p1

    aput-byte p1, p6, p7

    .line 180
    add-int/lit8 p1, p7, 0x1

    shr-int/lit8 p2, p2, 0x8

    and-int/lit16 p2, p2, 0xff

    int-to-byte p2, p2

    aput-byte p2, p6, p1

    .line 181
    add-int/lit8 p1, p7, 0x2

    and-int/lit16 p2, p0, 0xff

    int-to-byte p2, p2

    aput-byte p2, p6, p1

    .line 182
    add-int/lit8 p7, p7, 0x3

    shr-int/lit8 p0, p0, 0x8

    and-int/lit16 p0, p0, 0xff

    int-to-byte p0, p0

    aput-byte p0, p6, p7

    .line 183
    return-void
.end method

.method private clearQueuesLocked()V
    .registers 3

    .line 516
    const/4 v0, 0x0

    iput-boolean v0, p0, Lradiant/KaraokeAudioProcessor;->primed:Z

    .line 517
    const/4 v1, 0x0

    iput-object v1, p0, Lradiant/KaraokeAudioProcessor;->activeOut:Lradiant/KaraokeAudioProcessor$ReadyChunk;

    .line 518
    iput v0, p0, Lradiant/KaraokeAudioProcessor;->activeOutOffset:I

    .line 519
    iget-object v0, p0, Lradiant/KaraokeAudioProcessor;->queueLock:Ljava/lang/Object;

    monitor-enter v0

    .line 520
    :try_start_b
    iget v1, p0, Lradiant/KaraokeAudioProcessor;->generation:I

    add-int/lit8 v1, v1, 0x1

    iput v1, p0, Lradiant/KaraokeAudioProcessor;->generation:I

    .line 521
    iget-object v1, p0, Lradiant/KaraokeAudioProcessor;->pendingQueue:Ljava/util/LinkedList;

    invoke-virtual {v1}, Ljava/util/LinkedList;->clear()V

    .line 522
    iget-object v1, p0, Lradiant/KaraokeAudioProcessor;->readyQueue:Ljava/util/LinkedList;

    invoke-virtual {v1}, Ljava/util/LinkedList;->clear()V

    .line 523
    iget-object v1, p0, Lradiant/KaraokeAudioProcessor;->queueLock:Ljava/lang/Object;

    invoke-virtual {v1}, Ljava/lang/Object;->notifyAll()V

    .line 524
    monitor-exit v0

    .line 525
    return-void

    .line 524
    :catchall_22
    move-exception v1

    monitor-exit v0
    :try_end_24
    .catchall {:try_start_b .. :try_end_24} :catchall_22

    throw v1
.end method

.method private convertInputToPcm16(Ljava/nio/ByteBuffer;)I
    .registers 12

    .line 575
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->remaining()I

    move-result v0

    .line 576
    iget-object v1, p0, Lradiant/KaraokeAudioProcessor;->inputAudioFormat:Landroidx/media3/common/audio/AudioProcessor$AudioFormat;

    iget v1, v1, Landroidx/media3/common/audio/AudioProcessor$AudioFormat;->encoding:I

    .line 577
    const/4 v2, 0x2

    const/4 v3, 0x0

    if-ne v1, v2, :cond_17

    .line 578
    and-int/lit8 v0, v0, -0x4

    .line 579
    invoke-direct {p0, v0}, Lradiant/KaraokeAudioProcessor;->ensureScratchCapacity(I)V

    .line 580
    iget-object v1, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    invoke-virtual {p1, v1, v3, v0}, Ljava/nio/ByteBuffer;->get([BII)Ljava/nio/ByteBuffer;

    .line 581
    return v0

    .line 584
    :cond_17
    const/16 v2, 0x15

    if-eq v1, v2, :cond_127

    const/high16 v2, 0x20000000

    if-ne v1, v2, :cond_21

    goto/16 :goto_127

    .line 611
    :cond_21
    const/16 v2, 0x16

    const/4 v4, 0x4

    if-eq v1, v2, :cond_98

    const/high16 v2, 0x30000000

    if-ne v1, v2, :cond_2c

    goto/16 :goto_98

    .line 638
    :cond_2c
    if-ne v1, v4, :cond_8d

    .line 639
    div-int/lit8 v0, v0, 0x8

    .line 640
    mul-int/lit8 v1, v0, 0x4

    .line 641
    invoke-direct {p0, v1}, Lradiant/KaraokeAudioProcessor;->ensureScratchCapacity(I)V

    .line 642
    nop

    .line 643
    move v2, v3

    :goto_37
    if-ge v3, v0, :cond_8c

    .line 644
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->getFloat()F

    move-result v4

    .line 645
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->getFloat()F

    move-result v5

    .line 646
    const v6, 0x46fffe00    # 32767.0f

    mul-float/2addr v4, v6

    invoke-static {v4}, Ljava/lang/Math;->round(F)I

    move-result v4

    .line 647
    mul-float/2addr v5, v6

    invoke-static {v5}, Ljava/lang/Math;->round(F)I

    move-result v5

    .line 648
    const/16 v6, 0x7fff

    const/16 v7, -0x8000

    if-ge v4, v7, :cond_56

    move v4, v7

    goto :goto_59

    :cond_56
    if-le v4, v6, :cond_59

    move v4, v6

    .line 649
    :cond_59
    :goto_59
    if-ge v5, v7, :cond_5d

    move v5, v7

    goto :goto_60

    :cond_5d
    if-le v5, v6, :cond_60

    move v5, v6

    .line 650
    :cond_60
    :goto_60
    iget-object v6, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    add-int/lit8 v7, v2, 0x1

    and-int/lit16 v8, v4, 0xff

    int-to-byte v8, v8

    aput-byte v8, v6, v2

    .line 651
    iget-object v2, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    add-int/lit8 v6, v7, 0x1

    shr-int/lit8 v4, v4, 0x8

    and-int/lit16 v4, v4, 0xff

    int-to-byte v4, v4

    aput-byte v4, v2, v7

    .line 652
    iget-object v2, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    add-int/lit8 v4, v6, 0x1

    and-int/lit16 v7, v5, 0xff

    int-to-byte v7, v7

    aput-byte v7, v2, v6

    .line 653
    iget-object v2, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    add-int/lit8 v6, v4, 0x1

    shr-int/lit8 v5, v5, 0x8

    and-int/lit16 v5, v5, 0xff

    int-to-byte v5, v5

    aput-byte v5, v2, v4

    .line 643
    add-int/lit8 v3, v3, 0x1

    move v2, v6

    goto :goto_37

    .line 655
    :cond_8c
    return v1

    .line 658
    :cond_8d
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->limit()I

    move-result v0

    invoke-virtual {p1, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    move-result-object p1

    check-cast p1, Ljava/nio/ByteBuffer;

    .line 659
    return v3

    .line 612
    :cond_98
    :goto_98
    div-int/lit8 v0, v0, 0x8

    .line 613
    mul-int/lit8 v1, v0, 0x4

    .line 614
    invoke-direct {p0, v1}, Lradiant/KaraokeAudioProcessor;->ensureScratchCapacity(I)V

    .line 615
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->position()I

    move-result v2

    .line 616
    nop

    .line 617
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->order()Ljava/nio/ByteOrder;

    move-result-object v5

    sget-object v6, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;

    if-ne v5, v6, :cond_e6

    .line 618
    move v4, v3

    :goto_ad
    if-ge v3, v0, :cond_11d

    .line 619
    mul-int/lit8 v5, v3, 0x8

    add-int/2addr v5, v2

    .line 620
    iget-object v6, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    add-int/lit8 v7, v4, 0x1

    add-int/lit8 v8, v5, 0x2

    invoke-virtual {p1, v8}, Ljava/nio/ByteBuffer;->get(I)B

    move-result v8

    aput-byte v8, v6, v4

    .line 621
    iget-object v4, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    add-int/lit8 v6, v7, 0x1

    add-int/lit8 v8, v5, 0x3

    invoke-virtual {p1, v8}, Ljava/nio/ByteBuffer;->get(I)B

    move-result v8

    aput-byte v8, v4, v7

    .line 622
    iget-object v4, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    add-int/lit8 v7, v6, 0x1

    add-int/lit8 v8, v5, 0x6

    invoke-virtual {p1, v8}, Ljava/nio/ByteBuffer;->get(I)B

    move-result v8

    aput-byte v8, v4, v6

    .line 623
    iget-object v4, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    add-int/lit8 v6, v7, 0x1

    add-int/lit8 v5, v5, 0x7

    invoke-virtual {p1, v5}, Ljava/nio/ByteBuffer;->get(I)B

    move-result v5

    aput-byte v5, v4, v7

    .line 618
    add-int/lit8 v3, v3, 0x1

    move v4, v6

    goto :goto_ad

    .line 626
    :cond_e6
    move v5, v3

    :goto_e7
    if-ge v3, v0, :cond_11d

    .line 627
    mul-int/lit8 v6, v3, 0x8

    add-int/2addr v6, v2

    .line 628
    iget-object v7, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    add-int/lit8 v8, v5, 0x1

    add-int/lit8 v9, v6, 0x1

    invoke-virtual {p1, v9}, Ljava/nio/ByteBuffer;->get(I)B

    move-result v9

    aput-byte v9, v7, v5

    .line 629
    iget-object v5, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    add-int/lit8 v7, v8, 0x1

    invoke-virtual {p1, v6}, Ljava/nio/ByteBuffer;->get(I)B

    move-result v9

    aput-byte v9, v5, v8

    .line 630
    iget-object v5, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    add-int/lit8 v8, v7, 0x1

    add-int/lit8 v9, v6, 0x5

    invoke-virtual {p1, v9}, Ljava/nio/ByteBuffer;->get(I)B

    move-result v9

    aput-byte v9, v5, v7

    .line 631
    iget-object v5, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    add-int/lit8 v7, v8, 0x1

    add-int/2addr v6, v4

    invoke-virtual {p1, v6}, Ljava/nio/ByteBuffer;->get(I)B

    move-result v6

    aput-byte v6, v5, v8

    .line 626
    add-int/lit8 v3, v3, 0x1

    move v5, v7

    goto :goto_e7

    .line 634
    :cond_11d
    mul-int/lit8 v0, v0, 0x8

    add-int/2addr v2, v0

    invoke-virtual {p1, v2}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    move-result-object p1

    check-cast p1, Ljava/nio/ByteBuffer;

    .line 635
    return v1

    .line 585
    :cond_127
    :goto_127
    div-int/lit8 v0, v0, 0x6

    .line 586
    mul-int/lit8 v1, v0, 0x4

    .line 587
    invoke-direct {p0, v1}, Lradiant/KaraokeAudioProcessor;->ensureScratchCapacity(I)V

    .line 588
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->position()I

    move-result v2

    .line 589
    nop

    .line 590
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->order()Ljava/nio/ByteOrder;

    move-result-object v4

    sget-object v5, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;

    if-ne v4, v5, :cond_175

    .line 591
    move v4, v3

    :goto_13c
    if-ge v3, v0, :cond_1ad

    .line 592
    mul-int/lit8 v5, v3, 0x6

    add-int/2addr v5, v2

    .line 593
    iget-object v6, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    add-int/lit8 v7, v4, 0x1

    add-int/lit8 v8, v5, 0x1

    invoke-virtual {p1, v8}, Ljava/nio/ByteBuffer;->get(I)B

    move-result v8

    aput-byte v8, v6, v4

    .line 594
    iget-object v4, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    add-int/lit8 v6, v7, 0x1

    add-int/lit8 v8, v5, 0x2

    invoke-virtual {p1, v8}, Ljava/nio/ByteBuffer;->get(I)B

    move-result v8

    aput-byte v8, v4, v7

    .line 595
    iget-object v4, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    add-int/lit8 v7, v6, 0x1

    add-int/lit8 v8, v5, 0x4

    invoke-virtual {p1, v8}, Ljava/nio/ByteBuffer;->get(I)B

    move-result v8

    aput-byte v8, v4, v6

    .line 596
    iget-object v4, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    add-int/lit8 v6, v7, 0x1

    add-int/lit8 v5, v5, 0x5

    invoke-virtual {p1, v5}, Ljava/nio/ByteBuffer;->get(I)B

    move-result v5

    aput-byte v5, v4, v7

    .line 591
    add-int/lit8 v3, v3, 0x1

    move v4, v6

    goto :goto_13c

    .line 599
    :cond_175
    move v4, v3

    :goto_176
    if-ge v3, v0, :cond_1ad

    .line 600
    mul-int/lit8 v5, v3, 0x6

    add-int/2addr v5, v2

    .line 601
    iget-object v6, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    add-int/lit8 v7, v4, 0x1

    add-int/lit8 v8, v5, 0x1

    invoke-virtual {p1, v8}, Ljava/nio/ByteBuffer;->get(I)B

    move-result v8

    aput-byte v8, v6, v4

    .line 602
    iget-object v4, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    add-int/lit8 v6, v7, 0x1

    invoke-virtual {p1, v5}, Ljava/nio/ByteBuffer;->get(I)B

    move-result v8

    aput-byte v8, v4, v7

    .line 603
    iget-object v4, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    add-int/lit8 v7, v6, 0x1

    add-int/lit8 v8, v5, 0x4

    invoke-virtual {p1, v8}, Ljava/nio/ByteBuffer;->get(I)B

    move-result v8

    aput-byte v8, v4, v6

    .line 604
    iget-object v4, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    add-int/lit8 v6, v7, 0x1

    add-int/lit8 v5, v5, 0x3

    invoke-virtual {p1, v5}, Ljava/nio/ByteBuffer;->get(I)B

    move-result v5

    aput-byte v5, v4, v7

    .line 599
    add-int/lit8 v3, v3, 0x1

    move v4, v6

    goto :goto_176

    .line 607
    :cond_1ad
    mul-int/lit8 v0, v0, 0x6

    add-int/2addr v2, v0

    invoke-virtual {p1, v2}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    move-result-object p1

    check-cast p1, Ljava/nio/ByteBuffer;

    .line 608
    return v1
.end method

.method private static crossfadeInPlace([B[BI)V
    .registers 14

    .line 158
    const/4 v0, 0x0

    :goto_1
    if-ge v0, p2, :cond_1b

    .line 159
    int-to-float v1, v0

    const/high16 v2, 0x3f000000    # 0.5f

    add-float/2addr v1, v2

    int-to-float v2, p2

    div-float v8, v1, v2

    .line 160
    const/high16 v1, 0x3f800000    # 1.0f

    sub-float v7, v1, v8

    .line 161
    mul-int/lit8 v4, v0, 0x4

    .line 162
    move v6, v4

    move-object v9, p1

    move v10, v4

    move-object v3, p0

    move-object v5, p1

    invoke-static/range {v3 .. v10}, Lradiant/KaraokeAudioProcessor;->blendStereoSample([BI[BIFF[BI)V

    .line 158
    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    .line 164
    :cond_1b
    return-void
.end method

.method private drainWetToDryOnDisable(I)V
    .registers 22

    .line 299
    move-object/from16 v0, p0

    move/from16 v1, p1

    iget-object v6, v0, Lradiant/KaraokeAudioProcessor;->activeOut:Lradiant/KaraokeAudioProcessor$ReadyChunk;

    .line 300
    iget v7, v0, Lradiant/KaraokeAudioProcessor;->activeOutOffset:I

    .line 301
    invoke-direct {v0}, Lradiant/KaraokeAudioProcessor;->clearQueuesLocked()V

    .line 303
    const/4 v8, 0x0

    if-lez v1, :cond_1b

    .line 304
    iget-object v2, v0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    invoke-direct {v0, v2, v8, v1}, Lradiant/KaraokeAudioProcessor;->appendToHistory([BII)V

    .line 305
    iget-wide v2, v0, Lradiant/KaraokeAudioProcessor;->totalFramesIn:J

    div-int/lit8 v1, v1, 0x4

    int-to-long v4, v1

    add-long/2addr v2, v4

    iput-wide v2, v0, Lradiant/KaraokeAudioProcessor;->totalFramesIn:J

    .line 308
    :cond_1b
    iget-wide v1, v0, Lradiant/KaraokeAudioProcessor;->totalFramesIn:J

    iget-wide v3, v0, Lradiant/KaraokeAudioProcessor;->totalFramesOut:J

    sub-long/2addr v1, v3

    .line 309
    const-wide/16 v3, 0x0

    cmp-long v3, v1, v3

    if-gtz v3, :cond_2b

    .line 310
    iget-wide v1, v0, Lradiant/KaraokeAudioProcessor;->totalFramesIn:J

    iput-wide v1, v0, Lradiant/KaraokeAudioProcessor;->totalFramesOut:J

    .line 311
    return-void

    .line 314
    :cond_2b
    const-wide/16 v3, 0x4

    mul-long/2addr v3, v1

    long-to-int v9, v3

    .line 315
    iget-object v3, v0, Lradiant/KaraokeAudioProcessor;->drainScratch:[B

    if-eqz v3, :cond_38

    iget-object v3, v0, Lradiant/KaraokeAudioProcessor;->drainScratch:[B

    array-length v3, v3

    if-ge v3, v9, :cond_3c

    .line 316
    :cond_38
    new-array v3, v9, [B

    iput-object v3, v0, Lradiant/KaraokeAudioProcessor;->drainScratch:[B

    .line 318
    :cond_3c
    iget-wide v3, v0, Lradiant/KaraokeAudioProcessor;->totalFramesOut:J

    long-to-int v1, v1

    move-wide/from16 v18, v3

    move v3, v1

    move-wide/from16 v1, v18

    iget-object v4, v0, Lradiant/KaraokeAudioProcessor;->drainScratch:[B

    const/4 v5, 0x0

    invoke-direct/range {v0 .. v5}, Lradiant/KaraokeAudioProcessor;->readHistoryWindow(JI[BI)V

    .line 320
    if-eqz v6, :cond_f4

    iget-object v1, v6, Lradiant/KaraokeAudioProcessor$ReadyChunk;->dryBytes:[B

    array-length v1, v1

    if-ge v7, v1, :cond_f4

    .line 321
    iget-object v1, v6, Lradiant/KaraokeAudioProcessor$ReadyChunk;->dryBytes:[B

    array-length v1, v1

    sub-int/2addr v1, v7

    div-int/lit8 v1, v1, 0x4

    .line 322
    invoke-static {v1, v3}, Ljava/lang/Math;->min(II)I

    move-result v1

    .line 321
    const/16 v2, 0x52b

    invoke-static {v2, v1}, Ljava/lang/Math;->min(II)I

    move-result v1

    .line 323
    invoke-static {}, Lradiant/KaraokeBridge;->getVocalGain()F

    move-result v2

    .line 324
    move v3, v8

    :goto_66
    if-ge v3, v1, :cond_f4

    .line 325
    int-to-float v4, v3

    const/high16 v5, 0x3f000000    # 0.5f

    add-float/2addr v4, v5

    int-to-float v5, v1

    div-float/2addr v4, v5

    const/high16 v5, 0x3f800000    # 1.0f

    sub-float v4, v5, v4

    .line 326
    mul-int/lit8 v10, v3, 0x4

    .line 327
    add-int v11, v7, v10

    .line 328
    iget-object v12, v6, Lradiant/KaraokeAudioProcessor$ReadyChunk;->dryBytes:[B

    iget-object v13, v6, Lradiant/KaraokeAudioProcessor$ReadyChunk;->instBytes:[B

    invoke-static {v12, v13, v11, v2}, Lradiant/KaraokeAudioProcessor;->wetSampleAt([B[BIF)I

    move-result v12

    .line 329
    iget-object v13, v6, Lradiant/KaraokeAudioProcessor$ReadyChunk;->dryBytes:[B

    iget-object v14, v6, Lradiant/KaraokeAudioProcessor$ReadyChunk;->instBytes:[B

    add-int/lit8 v11, v11, 0x2

    invoke-static {v13, v14, v11, v2}, Lradiant/KaraokeAudioProcessor;->wetSampleAt([B[BIF)I

    move-result v11

    .line 330
    iget-object v13, v0, Lradiant/KaraokeAudioProcessor;->drainScratch:[B

    aget-byte v13, v13, v10

    and-int/lit16 v13, v13, 0xff

    iget-object v14, v0, Lradiant/KaraokeAudioProcessor;->drainScratch:[B

    add-int/lit8 v15, v10, 0x1

    aget-byte v14, v14, v15

    shl-int/lit8 v14, v14, 0x8

    or-int/2addr v13, v14

    .line 331
    iget-object v14, v0, Lradiant/KaraokeAudioProcessor;->drainScratch:[B

    add-int/lit8 v16, v10, 0x2

    aget-byte v14, v14, v16

    and-int/lit16 v14, v14, 0xff

    move/from16 p1, v5

    iget-object v5, v0, Lradiant/KaraokeAudioProcessor;->drainScratch:[B

    add-int/lit8 v17, v10, 0x3

    aget-byte v5, v5, v17

    shl-int/lit8 v5, v5, 0x8

    or-int/2addr v5, v14

    .line 332
    int-to-float v12, v12

    mul-float/2addr v12, v4

    int-to-float v13, v13

    sub-float v14, p1, v4

    mul-float/2addr v13, v14

    add-float/2addr v12, v13

    invoke-static {v12}, Ljava/lang/Math;->round(F)I

    move-result v12

    .line 333
    int-to-float v11, v11

    mul-float/2addr v11, v4

    int-to-float v4, v5

    mul-float/2addr v4, v14

    add-float/2addr v11, v4

    invoke-static {v11}, Ljava/lang/Math;->round(F)I

    move-result v4

    .line 334
    const/16 v5, 0x7fff

    const/16 v11, -0x8000

    if-ge v12, v11, :cond_c6

    move v12, v11

    goto :goto_c9

    :cond_c6
    if-le v12, v5, :cond_c9

    move v12, v5

    .line 335
    :cond_c9
    :goto_c9
    if-ge v4, v11, :cond_cd

    move v4, v11

    goto :goto_d0

    :cond_cd
    if-le v4, v5, :cond_d0

    move v4, v5

    .line 336
    :cond_d0
    :goto_d0
    iget-object v5, v0, Lradiant/KaraokeAudioProcessor;->drainScratch:[B

    and-int/lit16 v11, v12, 0xff

    int-to-byte v11, v11

    aput-byte v11, v5, v10

    .line 337
    iget-object v5, v0, Lradiant/KaraokeAudioProcessor;->drainScratch:[B

    shr-int/lit8 v10, v12, 0x8

    and-int/lit16 v10, v10, 0xff

    int-to-byte v10, v10

    aput-byte v10, v5, v15

    .line 338
    iget-object v5, v0, Lradiant/KaraokeAudioProcessor;->drainScratch:[B

    and-int/lit16 v10, v4, 0xff

    int-to-byte v10, v10

    aput-byte v10, v5, v16

    .line 339
    iget-object v5, v0, Lradiant/KaraokeAudioProcessor;->drainScratch:[B

    shr-int/lit8 v4, v4, 0x8

    and-int/lit16 v4, v4, 0xff

    int-to-byte v4, v4

    aput-byte v4, v5, v17

    .line 324
    add-int/lit8 v3, v3, 0x1

    goto/16 :goto_66

    .line 343
    :cond_f4
    iget-wide v1, v0, Lradiant/KaraokeAudioProcessor;->totalFramesIn:J

    iput-wide v1, v0, Lradiant/KaraokeAudioProcessor;->totalFramesOut:J

    .line 344
    invoke-virtual {v0, v9}, Lradiant/KaraokeAudioProcessor;->replaceOutputBuffer(I)Ljava/nio/ByteBuffer;

    move-result-object v1

    .line 345
    iget-object v2, v0, Lradiant/KaraokeAudioProcessor;->drainScratch:[B

    invoke-virtual {v1, v2, v8, v9}, Ljava/nio/ByteBuffer;->put([BII)Ljava/nio/ByteBuffer;

    .line 346
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->flip()Ljava/nio/Buffer;

    move-result-object v1

    check-cast v1, Ljava/nio/ByteBuffer;

    .line 347
    return-void
.end method

.method private emitWetExactly(I)V
    .registers 16

    .line 398
    invoke-virtual {p0, p1}, Lradiant/KaraokeAudioProcessor;->replaceOutputBuffer(I)Ljava/nio/ByteBuffer;

    move-result-object v1

    .line 399
    invoke-static {}, Lradiant/KaraokeBridge;->getVocalGain()F

    move-result v6

    .line 400
    const/4 v7, 0x0

    move v8, v7

    .line 402
    :goto_a
    if-ge v8, p1, :cond_7b

    .line 403
    iget-object v0, p0, Lradiant/KaraokeAudioProcessor;->activeOut:Lradiant/KaraokeAudioProcessor$ReadyChunk;

    .line 404
    if-eqz v0, :cond_20

    iget v2, v0, Lradiant/KaraokeAudioProcessor$ReadyChunk;->generation:I

    iget v3, p0, Lradiant/KaraokeAudioProcessor;->generation:I

    if-ne v2, v3, :cond_20

    iget v2, p0, Lradiant/KaraokeAudioProcessor;->activeOutOffset:I

    iget-object v3, v0, Lradiant/KaraokeAudioProcessor$ReadyChunk;->dryBytes:[B

    array-length v3, v3

    if-lt v2, v3, :cond_1e

    goto :goto_20

    :cond_1e
    move-object v9, v0

    goto :goto_2b

    .line 405
    :cond_20
    :goto_20
    const-wide/16 v2, 0x708

    invoke-direct {p0, v2, v3}, Lradiant/KaraokeAudioProcessor;->awaitNextReadyChunk(J)Lradiant/KaraokeAudioProcessor$ReadyChunk;

    move-result-object v0

    .line 406
    iput-object v0, p0, Lradiant/KaraokeAudioProcessor;->activeOut:Lradiant/KaraokeAudioProcessor$ReadyChunk;

    .line 407
    iput v7, p0, Lradiant/KaraokeAudioProcessor;->activeOutOffset:I

    move-object v9, v0

    .line 409
    :goto_2b
    if-nez v9, :cond_4a

    .line 410
    sub-int/2addr p1, v8

    .line 411
    invoke-direct {p0, p1}, Lradiant/KaraokeAudioProcessor;->ensureMixScratchCapacity(I)V

    .line 412
    iget-wide v9, p0, Lradiant/KaraokeAudioProcessor;->totalFramesOut:J

    div-int/lit8 v11, p1, 0x4

    iget-object v12, p0, Lradiant/KaraokeAudioProcessor;->mixSliceScratch:[B

    const/4 v13, 0x0

    move-object v8, p0

    invoke-direct/range {v8 .. v13}, Lradiant/KaraokeAudioProcessor;->readHistoryWindow(JI[BI)V

    .line 413
    move-object v0, v8

    iget-object v2, v0, Lradiant/KaraokeAudioProcessor;->mixSliceScratch:[B

    invoke-virtual {v1, v2, v7, p1}, Ljava/nio/ByteBuffer;->put([BII)Ljava/nio/ByteBuffer;

    .line 414
    iget-wide v2, v0, Lradiant/KaraokeAudioProcessor;->totalFramesOut:J

    int-to-long v4, v11

    add-long/2addr v2, v4

    iput-wide v2, v0, Lradiant/KaraokeAudioProcessor;->totalFramesOut:J

    .line 415
    nop

    .line 416
    goto :goto_7c

    .line 419
    :cond_4a
    move-object v0, p0

    iget-object v2, v9, Lradiant/KaraokeAudioProcessor$ReadyChunk;->dryBytes:[B

    array-length v2, v2

    iget v3, v0, Lradiant/KaraokeAudioProcessor;->activeOutOffset:I

    sub-int/2addr v2, v3

    .line 420
    sub-int v3, p1, v8

    invoke-static {v2, v3}, Ljava/lang/Math;->min(II)I

    move-result v5

    .line 421
    iget-object v2, v9, Lradiant/KaraokeAudioProcessor$ReadyChunk;->dryBytes:[B

    iget-object v3, v9, Lradiant/KaraokeAudioProcessor$ReadyChunk;->instBytes:[B

    iget v4, v0, Lradiant/KaraokeAudioProcessor;->activeOutOffset:I

    invoke-direct/range {v0 .. v6}, Lradiant/KaraokeAudioProcessor;->appendBlendedSlice(Ljava/nio/ByteBuffer;[B[BIIF)V

    .line 422
    iget v2, v0, Lradiant/KaraokeAudioProcessor;->activeOutOffset:I

    add-int/2addr v2, v5

    iput v2, v0, Lradiant/KaraokeAudioProcessor;->activeOutOffset:I

    .line 423
    iget-wide v2, v0, Lradiant/KaraokeAudioProcessor;->totalFramesOut:J

    div-int/lit8 v4, v5, 0x4

    int-to-long v10, v4

    add-long/2addr v2, v10

    iput-wide v2, v0, Lradiant/KaraokeAudioProcessor;->totalFramesOut:J

    .line 424
    add-int/2addr v8, v5

    .line 426
    iget v2, v0, Lradiant/KaraokeAudioProcessor;->activeOutOffset:I

    iget-object v3, v9, Lradiant/KaraokeAudioProcessor$ReadyChunk;->dryBytes:[B

    array-length v3, v3

    if-lt v2, v3, :cond_7a

    .line 427
    const/4 v2, 0x0

    iput-object v2, v0, Lradiant/KaraokeAudioProcessor;->activeOut:Lradiant/KaraokeAudioProcessor$ReadyChunk;

    .line 428
    iput v7, v0, Lradiant/KaraokeAudioProcessor;->activeOutOffset:I

    .line 430
    :cond_7a
    goto :goto_a

    .line 402
    :cond_7b
    move-object v0, p0

    .line 432
    :goto_7c
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->flip()Ljava/nio/Buffer;

    move-result-object p1

    check-cast p1, Ljava/nio/ByteBuffer;

    .line 433
    return-void
.end method

.method private enqueueHopWithBackpressure(Lradiant/KaraokeAudioProcessor$PendingChunk;)V
    .registers 7

    .line 350
    iget v0, p0, Lradiant/KaraokeAudioProcessor;->generation:I

    .line 351
    iget-object v1, p0, Lradiant/KaraokeAudioProcessor;->queueLock:Ljava/lang/Object;

    monitor-enter v1

    .line 352
    :goto_5
    :try_start_5
    iget-object v2, p0, Lradiant/KaraokeAudioProcessor;->pendingQueue:Ljava/util/LinkedList;

    invoke-virtual {v2}, Ljava/util/LinkedList;->size()I

    move-result v2

    iget-object v3, p0, Lradiant/KaraokeAudioProcessor;->readyQueue:Ljava/util/LinkedList;

    invoke-virtual {v3}, Ljava/util/LinkedList;->size()I

    move-result v3

    add-int/2addr v2, v3

    iget-boolean v3, p0, Lradiant/KaraokeAudioProcessor;->workerBusy:Z

    add-int/2addr v2, v3

    const/4 v3, 0x3

    if-lt v2, v3, :cond_2c

    iget v2, p0, Lradiant/KaraokeAudioProcessor;->generation:I

    if-ne v2, v0, :cond_2c

    .line 354
    invoke-static {}, Lradiant/KaraokeBridge;->isEnabled()Z

    move-result v2
    :try_end_20
    .catchall {:try_start_5 .. :try_end_20} :catchall_42

    if-eqz v2, :cond_2c

    .line 356
    :try_start_22
    iget-object v2, p0, Lradiant/KaraokeAudioProcessor;->queueLock:Ljava/lang/Object;

    const-wide/16 v3, 0x14

    invoke-virtual {v2, v3, v4}, Ljava/lang/Object;->wait(J)V
    :try_end_29
    .catch Ljava/lang/InterruptedException; {:try_start_22 .. :try_end_29} :catch_2a
    .catchall {:try_start_22 .. :try_end_29} :catchall_42

    .line 359
    goto :goto_5

    .line 357
    :catch_2a
    move-exception v2

    .line 358
    nop

    .line 361
    :cond_2c
    :try_start_2c
    iget v2, p0, Lradiant/KaraokeAudioProcessor;->generation:I

    if-ne v2, v0, :cond_40

    invoke-static {}, Lradiant/KaraokeBridge;->isEnabled()Z

    move-result v0

    if-eqz v0, :cond_40

    .line 362
    iget-object v0, p0, Lradiant/KaraokeAudioProcessor;->pendingQueue:Ljava/util/LinkedList;

    invoke-virtual {v0, p1}, Ljava/util/LinkedList;->addLast(Ljava/lang/Object;)V

    .line 363
    iget-object p1, p0, Lradiant/KaraokeAudioProcessor;->queueLock:Ljava/lang/Object;

    invoke-virtual {p1}, Ljava/lang/Object;->notifyAll()V

    .line 365
    :cond_40
    monitor-exit v1

    .line 366
    return-void

    .line 365
    :catchall_42
    move-exception p1

    monitor-exit v1
    :try_end_44
    .catchall {:try_start_2c .. :try_end_44} :catchall_42

    throw p1
.end method

.method private ensureMixScratchCapacity(I)V
    .registers 3

    .line 669
    iget-object v0, p0, Lradiant/KaraokeAudioProcessor;->mixSliceScratch:[B

    array-length v0, v0

    if-ge v0, p1, :cond_9

    .line 670
    new-array p1, p1, [B

    iput-object p1, p0, Lradiant/KaraokeAudioProcessor;->mixSliceScratch:[B

    .line 672
    :cond_9
    return-void
.end method

.method private ensureScratchCapacity(I)V
    .registers 3

    .line 663
    iget-object v0, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    array-length v0, v0

    if-ge v0, p1, :cond_9

    .line 664
    new-array p1, p1, [B

    iput-object p1, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    .line 666
    :cond_9
    return-void
.end method

.method private declared-synchronized ensureWorkerStarted()V
    .registers 5

    monitor-enter p0

    .line 98
    :try_start_1
    iget-boolean v0, p0, Lradiant/KaraokeAudioProcessor;->workerStarted:Z
    :try_end_3
    .catchall {:try_start_1 .. :try_end_3} :catchall_1e

    if-eqz v0, :cond_7

    .line 99
    monitor-exit p0

    return-void

    .line 101
    :cond_7
    const/4 v0, 0x1

    :try_start_8
    iput-boolean v0, p0, Lradiant/KaraokeAudioProcessor;->workerStarted:Z

    .line 102
    new-instance v1, Ljava/lang/Thread;

    new-instance v2, Lradiant/KaraokeAudioProcessor$1;

    invoke-direct {v2, p0}, Lradiant/KaraokeAudioProcessor$1;-><init>(Lradiant/KaraokeAudioProcessor;)V

    const-string v3, "Karaoke-HTP-Worker"

    invoke-direct {v1, v2, v3}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    .line 153
    invoke-virtual {v1, v0}, Ljava/lang/Thread;->setDaemon(Z)V

    .line 154
    invoke-virtual {v1}, Ljava/lang/Thread;->start()V
    :try_end_1c
    .catchall {:try_start_8 .. :try_end_1c} :catchall_1e

    .line 155
    monitor-exit p0

    return-void

    .line 97
    :catchall_1e
    move-exception v0

    :try_start_1f
    monitor-exit p0
    :try_end_20
    .catchall {:try_start_1f .. :try_end_20} :catchall_1e

    throw v0
.end method

.method private static isSupportedEncoding(I)Z
    .registers 2

    .line 200
    const/4 v0, 0x2

    if-eq p0, v0, :cond_19

    const/4 v0, 0x4

    if-eq p0, v0, :cond_19

    const/16 v0, 0x15

    if-eq p0, v0, :cond_19

    const/high16 v0, 0x20000000

    if-eq p0, v0, :cond_19

    const/16 v0, 0x16

    if-eq p0, v0, :cond_19

    const/high16 v0, 0x30000000

    if-ne p0, v0, :cond_17

    goto :goto_19

    :cond_17
    const/4 p0, 0x0

    goto :goto_1a

    :cond_19
    :goto_19
    const/4 p0, 0x1

    :goto_1a
    return p0
.end method

.method private readHistoryWindow(JI[BI)V
    .registers 11

    .line 548
    mul-int/lit8 v0, p3, 0x4

    .line 549
    iget-object v1, p0, Lradiant/KaraokeAudioProcessor;->dryHistory:[B

    const/4 v2, 0x0

    if-eqz v1, :cond_59

    if-gtz p3, :cond_a

    goto :goto_59

    .line 553
    :cond_a
    iget-wide v0, p0, Lradiant/KaraokeAudioProcessor;->totalFramesIn:J

    const-wide/32 v3, 0x3fc00

    sub-long/2addr v0, v3

    const-wide/16 v3, 0x0

    invoke-static {v3, v4, v0, v1}, Ljava/lang/Math;->max(JJ)J

    move-result-wide v0

    .line 554
    nop

    .line 555
    cmp-long v3, p1, v0

    if-gez v3, :cond_33

    .line 556
    int-to-long v3, p3

    sub-long/2addr v0, p1

    invoke-static {v3, v4, v0, v1}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v0

    long-to-int v0, v0

    .line 557
    mul-int/lit8 v1, v0, 0x4

    .line 558
    move v3, v2

    :goto_25
    if-ge v3, v1, :cond_2e

    add-int v4, p5, v3

    aput-byte v2, p4, v4

    add-int/lit8 v3, v3, 0x1

    goto :goto_25

    .line 559
    :cond_2e
    add-int/2addr v1, v2

    .line 560
    int-to-long v3, v0

    add-long/2addr p1, v3

    .line 561
    sub-int/2addr p3, v0

    goto :goto_34

    .line 555
    :cond_33
    move v1, v2

    .line 563
    :goto_34
    if-gtz p3, :cond_37

    return-void

    .line 565
    :cond_37
    mul-int/lit8 p3, p3, 0x4

    .line 566
    const-wide/16 v3, 0x4

    mul-long/2addr p1, v3

    const-wide/32 v3, 0xff000

    rem-long/2addr p1, v3

    long-to-int p1, p1

    .line 567
    const p2, 0xff000

    sub-int/2addr p2, p1

    invoke-static {p3, p2}, Ljava/lang/Math;->min(II)I

    move-result p2

    .line 568
    iget-object v0, p0, Lradiant/KaraokeAudioProcessor;->dryHistory:[B

    add-int/2addr p5, v1

    invoke-static {v0, p1, p4, p5, p2}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 569
    if-ge p2, p3, :cond_58

    .line 570
    iget-object p1, p0, Lradiant/KaraokeAudioProcessor;->dryHistory:[B

    add-int/2addr p5, p2

    sub-int/2addr p3, p2

    invoke-static {p1, v2, p4, p5, p3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 572
    :cond_58
    return-void

    .line 550
    :cond_59
    :goto_59
    move p1, v2

    :goto_5a
    if-ge p1, v0, :cond_63

    add-int p2, p5, p1

    aput-byte v2, p4, p2

    add-int/lit8 p1, p1, 0x1

    goto :goto_5a

    .line 551
    :cond_63
    return-void
.end method

.method private static wetSampleAt([B[BIF)I
    .registers 7

    .line 436
    aget-byte v0, p0, p2

    and-int/lit16 v0, v0, 0xff

    add-int/lit8 v1, p2, 0x1

    aget-byte v2, p0, v1

    shl-int/lit8 v2, v2, 0x8

    or-int/2addr v0, v2

    .line 437
    if-eqz p1, :cond_34

    array-length v2, p1

    array-length p0, p0

    if-ne v2, p0, :cond_34

    const p0, 0x3f7fbe77    # 0.999f

    cmpl-float p0, p3, p0

    if-ltz p0, :cond_19

    goto :goto_34

    .line 440
    :cond_19
    aget-byte p0, p1, p2

    and-int/lit16 p0, p0, 0xff

    aget-byte p1, p1, v1

    shl-int/lit8 p1, p1, 0x8

    or-int/2addr p0, p1

    .line 441
    const p1, 0x3a83126f    # 0.001f

    cmpg-float p1, p3, p1

    if-gtz p1, :cond_2a

    .line 442
    return p0

    .line 444
    :cond_2a
    int-to-float p1, p0

    sub-int/2addr v0, p0

    int-to-float p0, v0

    mul-float/2addr p0, p3

    add-float/2addr p1, p0

    invoke-static {p1}, Ljava/lang/Math;->round(F)I

    move-result p0

    return p0

    .line 438
    :cond_34
    :goto_34
    return v0
.end method


# virtual methods
.method public onConfigure(Landroidx/media3/common/audio/AudioProcessor$AudioFormat;)Landroidx/media3/common/audio/AudioProcessor$AudioFormat;
    .registers 8
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroidx/media3/common/audio/AudioProcessor$UnhandledAudioFormatException;
        }
    .end annotation

    .line 187
    if-eqz p1, :cond_4d

    iget v0, p1, Landroidx/media3/common/audio/AudioProcessor$AudioFormat;->channelCount:I

    const/4 v1, 0x2

    if-eq v0, v1, :cond_8

    goto :goto_4d

    .line 190
    :cond_8
    iget v0, p1, Landroidx/media3/common/audio/AudioProcessor$AudioFormat;->encoding:I

    invoke-static {v0}, Lradiant/KaraokeAudioProcessor;->isSupportedEncoding(I)Z

    move-result v0

    if-nez v0, :cond_13

    .line 191
    sget-object p1, Landroidx/media3/common/audio/AudioProcessor$AudioFormat;->NOT_SET:Landroidx/media3/common/audio/AudioProcessor$AudioFormat;

    return-object p1

    .line 193
    :cond_13
    iget v0, p1, Landroidx/media3/common/audio/AudioProcessor$AudioFormat;->sampleRate:I

    iget v2, p1, Landroidx/media3/common/audio/AudioProcessor$AudioFormat;->channelCount:I

    iget v3, p1, Landroidx/media3/common/audio/AudioProcessor$AudioFormat;->encoding:I

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "onConfigure sr="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v4, " ch="

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, " enc="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v2, "RLKaraokeAudio"

    invoke-static {v2, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 196
    new-instance v0, Landroidx/media3/common/audio/AudioProcessor$AudioFormat;

    iget p1, p1, Landroidx/media3/common/audio/AudioProcessor$AudioFormat;->sampleRate:I

    invoke-direct {v0, p1, v1, v1}, Landroidx/media3/common/audio/AudioProcessor$AudioFormat;-><init>(III)V

    return-object v0

    .line 188
    :cond_4d
    :goto_4d
    sget-object p1, Landroidx/media3/common/audio/AudioProcessor$AudioFormat;->NOT_SET:Landroidx/media3/common/audio/AudioProcessor$AudioFormat;

    return-object p1
.end method

.method public onFlush()V
    .registers 3

    .line 500
    invoke-direct {p0}, Lradiant/KaraokeAudioProcessor;->clearQueuesLocked()V

    .line 501
    const-wide/16 v0, 0x0

    iput-wide v0, p0, Lradiant/KaraokeAudioProcessor;->totalFramesIn:J

    .line 502
    iput-wide v0, p0, Lradiant/KaraokeAudioProcessor;->totalFramesOut:J

    .line 503
    iput-wide v0, p0, Lradiant/KaraokeAudioProcessor;->nextDispatchStartFrame:J

    .line 504
    const/16 v0, 0x52b

    iput v0, p0, Lradiant/KaraokeAudioProcessor;->fadeInFramesDone:I

    .line 505
    return-void
.end method

.method public onQueueEndOfStream()V
    .registers 11

    .line 483
    iget-wide v0, p0, Lradiant/KaraokeAudioProcessor;->totalFramesIn:J

    iget-wide v2, p0, Lradiant/KaraokeAudioProcessor;->totalFramesOut:J

    sub-long/2addr v0, v2

    .line 484
    const-wide/16 v2, 0x0

    cmp-long v2, v0, v2

    if-gtz v2, :cond_c

    .line 485
    return-void

    .line 487
    :cond_c
    const-wide/16 v2, 0x4

    mul-long/2addr v2, v0

    long-to-int v2, v2

    .line 488
    iget-object v3, p0, Lradiant/KaraokeAudioProcessor;->drainScratch:[B

    if-eqz v3, :cond_19

    iget-object v3, p0, Lradiant/KaraokeAudioProcessor;->drainScratch:[B

    array-length v3, v3

    if-ge v3, v2, :cond_1d

    .line 489
    :cond_19
    new-array v3, v2, [B

    iput-object v3, p0, Lradiant/KaraokeAudioProcessor;->drainScratch:[B

    .line 491
    :cond_1d
    iget-wide v5, p0, Lradiant/KaraokeAudioProcessor;->totalFramesOut:J

    long-to-int v7, v0

    iget-object v8, p0, Lradiant/KaraokeAudioProcessor;->drainScratch:[B

    const/4 v9, 0x0

    move-object v4, p0

    invoke-direct/range {v4 .. v9}, Lradiant/KaraokeAudioProcessor;->readHistoryWindow(JI[BI)V

    .line 492
    iget-wide v0, v4, Lradiant/KaraokeAudioProcessor;->totalFramesIn:J

    iput-wide v0, v4, Lradiant/KaraokeAudioProcessor;->totalFramesOut:J

    .line 493
    invoke-virtual {p0, v2}, Lradiant/KaraokeAudioProcessor;->replaceOutputBuffer(I)Ljava/nio/ByteBuffer;

    move-result-object v0

    .line 494
    iget-object v1, v4, Lradiant/KaraokeAudioProcessor;->drainScratch:[B

    const/4 v3, 0x0

    invoke-virtual {v0, v1, v3, v2}, Ljava/nio/ByteBuffer;->put([BII)Ljava/nio/ByteBuffer;

    .line 495
    invoke-virtual {v0}, Ljava/nio/ByteBuffer;->flip()Ljava/nio/Buffer;

    move-result-object v0

    check-cast v0, Ljava/nio/ByteBuffer;

    .line 496
    return-void
.end method

.method public onReset()V
    .registers 2

    .line 509
    invoke-virtual {p0}, Lradiant/KaraokeAudioProcessor;->onFlush()V

    .line 510
    const/4 v0, 0x0

    iput-boolean v0, p0, Lradiant/KaraokeAudioProcessor;->wasEnabled:Z

    .line 511
    const/4 v0, 0x0

    iput-object v0, p0, Lradiant/KaraokeAudioProcessor;->dryHistory:[B

    .line 512
    iput-object v0, p0, Lradiant/KaraokeAudioProcessor;->drainScratch:[B

    .line 513
    return-void
.end method

.method public queueInput(Ljava/nio/ByteBuffer;)V
    .registers 15

    .line 210
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->remaining()I

    move-result v0

    .line 211
    const/4 v1, 0x0

    if-lez v0, :cond_c

    invoke-direct {p0, p1}, Lradiant/KaraokeAudioProcessor;->convertInputToPcm16(Ljava/nio/ByteBuffer;)I

    move-result p1

    goto :goto_d

    :cond_c
    move p1, v1

    .line 212
    :goto_d
    invoke-static {}, Lradiant/KaraokeBridge;->isEnabled()Z

    move-result v0

    .line 214
    if-nez v0, :cond_40

    .line 215
    iget-boolean v0, p0, Lradiant/KaraokeAudioProcessor;->wasEnabled:Z

    if-eqz v0, :cond_1d

    .line 216
    iput-boolean v1, p0, Lradiant/KaraokeAudioProcessor;->wasEnabled:Z

    .line 217
    invoke-direct {p0, p1}, Lradiant/KaraokeAudioProcessor;->drainWetToDryOnDisable(I)V

    .line 218
    return-void

    .line 220
    :cond_1d
    if-lez p1, :cond_3f

    .line 221
    iget-object v0, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    invoke-direct {p0, v0, v1, p1}, Lradiant/KaraokeAudioProcessor;->appendToHistory([BII)V

    .line 222
    iget-wide v2, p0, Lradiant/KaraokeAudioProcessor;->totalFramesIn:J

    div-int/lit8 v0, p1, 0x4

    int-to-long v4, v0

    add-long/2addr v2, v4

    iput-wide v2, p0, Lradiant/KaraokeAudioProcessor;->totalFramesIn:J

    .line 223
    iget-wide v2, p0, Lradiant/KaraokeAudioProcessor;->totalFramesIn:J

    iput-wide v2, p0, Lradiant/KaraokeAudioProcessor;->totalFramesOut:J

    .line 224
    invoke-virtual {p0, p1}, Lradiant/KaraokeAudioProcessor;->replaceOutputBuffer(I)Ljava/nio/ByteBuffer;

    move-result-object v0

    .line 225
    iget-object v2, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    invoke-virtual {v0, v2, v1, p1}, Ljava/nio/ByteBuffer;->put([BII)Ljava/nio/ByteBuffer;

    .line 226
    invoke-virtual {v0}, Ljava/nio/ByteBuffer;->flip()Ljava/nio/Buffer;

    move-result-object p1

    check-cast p1, Ljava/nio/ByteBuffer;

    .line 228
    :cond_3f
    return-void

    .line 231
    :cond_40
    invoke-direct {p0}, Lradiant/KaraokeAudioProcessor;->ensureWorkerStarted()V

    .line 232
    iget-boolean v0, p0, Lradiant/KaraokeAudioProcessor;->wasEnabled:Z

    const/4 v2, 0x1

    if-nez v0, :cond_53

    .line 233
    iput-boolean v2, p0, Lradiant/KaraokeAudioProcessor;->wasEnabled:Z

    .line 234
    invoke-direct {p0}, Lradiant/KaraokeAudioProcessor;->clearQueuesLocked()V

    .line 235
    iget-wide v3, p0, Lradiant/KaraokeAudioProcessor;->totalFramesOut:J

    iput-wide v3, p0, Lradiant/KaraokeAudioProcessor;->nextDispatchStartFrame:J

    .line 236
    iput v1, p0, Lradiant/KaraokeAudioProcessor;->fadeInFramesDone:I

    .line 239
    :cond_53
    const-wide/16 v3, 0x0

    if-lez p1, :cond_c6

    .line 240
    move v0, v1

    .line 241
    :goto_58
    if-ge v0, p1, :cond_c4

    .line 242
    iget-wide v5, p0, Lradiant/KaraokeAudioProcessor;->nextDispatchStartFrame:J

    const-wide/16 v7, 0x6200

    add-long/2addr v5, v7

    const-wide/16 v7, 0x800

    add-long/2addr v5, v7

    .line 243
    iget-wide v7, p0, Lradiant/KaraokeAudioProcessor;->totalFramesIn:J

    sub-long v7, v5, v7

    .line 245
    cmp-long v9, v7, v3

    if-gtz v9, :cond_6c

    .line 246
    move v7, v1

    goto :goto_77

    .line 248
    :cond_6c
    const-wide/16 v9, 0x4

    mul-long/2addr v7, v9

    .line 249
    sub-int v9, p1, v0

    int-to-long v9, v9

    invoke-static {v7, v8, v9, v10}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v7

    long-to-int v7, v7

    .line 251
    :goto_77
    if-lez v7, :cond_87

    .line 252
    iget-object v8, p0, Lradiant/KaraokeAudioProcessor;->scratchPcm16:[B

    invoke-direct {p0, v8, v0, v7}, Lradiant/KaraokeAudioProcessor;->appendToHistory([BII)V

    .line 253
    iget-wide v8, p0, Lradiant/KaraokeAudioProcessor;->totalFramesIn:J

    div-int/lit8 v10, v7, 0x4

    int-to-long v10, v10

    add-long/2addr v8, v10

    iput-wide v8, p0, Lradiant/KaraokeAudioProcessor;->totalFramesIn:J

    .line 254
    add-int/2addr v0, v7

    .line 256
    :cond_87
    iget-wide v7, p0, Lradiant/KaraokeAudioProcessor;->totalFramesIn:J

    cmp-long v5, v7, v5

    if-ltz v5, :cond_c2

    .line 257
    const v5, 0xff000

    new-array v10, v5, [B

    .line 258
    iget-wide v5, p0, Lradiant/KaraokeAudioProcessor;->totalFramesIn:J

    const-wide/32 v7, 0x3fc00

    sub-long v7, v5, v7

    const v9, 0x3fc00

    const/4 v11, 0x0

    move-object v6, p0

    invoke-direct/range {v6 .. v11}, Lradiant/KaraokeAudioProcessor;->readHistoryWindow(JI[BI)V

    .line 259
    const v5, 0x18000

    new-array v7, v5, [B

    .line 260
    const v8, 0xe4800

    invoke-static {v10, v8, v7, v1, v5}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 261
    new-instance v5, Lradiant/KaraokeAudioProcessor$PendingChunk;

    iget v8, v6, Lradiant/KaraokeAudioProcessor;->generation:I

    invoke-static {}, Lradiant/KaraokeBridge;->getMode()Ljava/lang/String;

    move-result-object v9

    invoke-direct {v5, v8, v9, v10, v7}, Lradiant/KaraokeAudioProcessor$PendingChunk;-><init>(ILjava/lang/String;[B[B)V

    invoke-direct {p0, v5}, Lradiant/KaraokeAudioProcessor;->enqueueHopWithBackpressure(Lradiant/KaraokeAudioProcessor$PendingChunk;)V

    .line 262
    iget-wide v7, v6, Lradiant/KaraokeAudioProcessor;->nextDispatchStartFrame:J

    const-wide/16 v9, 0x6000

    add-long/2addr v7, v9

    iput-wide v7, v6, Lradiant/KaraokeAudioProcessor;->nextDispatchStartFrame:J

    goto :goto_c3

    .line 256
    :cond_c2
    move-object v6, p0

    .line 264
    :goto_c3
    goto :goto_58

    .line 241
    :cond_c4
    move-object v6, p0

    goto :goto_c7

    .line 239
    :cond_c6
    move-object v6, p0

    .line 267
    :goto_c7
    iget-boolean v0, v6, Lradiant/KaraokeAudioProcessor;->primed:Z

    if-nez v0, :cond_12f

    .line 268
    iget v0, v6, Lradiant/KaraokeAudioProcessor;->generation:I

    .line 269
    iget-object v1, v6, Lradiant/KaraokeAudioProcessor;->queueLock:Ljava/lang/Object;

    monitor-enter v1

    .line 270
    :try_start_d0
    iget-object v5, v6, Lradiant/KaraokeAudioProcessor;->readyQueue:Ljava/util/LinkedList;

    invoke-virtual {v5}, Ljava/util/LinkedList;->isEmpty()Z

    move-result v5

    if-eqz v5, :cond_11b

    iget-boolean v5, v6, Lradiant/KaraokeAudioProcessor;->workerBusy:Z

    if-nez v5, :cond_e4

    iget-object v5, v6, Lradiant/KaraokeAudioProcessor;->pendingQueue:Ljava/util/LinkedList;

    invoke-virtual {v5}, Ljava/util/LinkedList;->isEmpty()Z

    move-result v5

    if-nez v5, :cond_11b

    :cond_e4
    iget v5, v6, Lradiant/KaraokeAudioProcessor;->generation:I

    if-ne v5, v0, :cond_11b

    .line 271
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v7

    const-wide/16 v9, 0x708

    add-long/2addr v7, v9

    .line 272
    :goto_ef
    iget-object v5, v6, Lradiant/KaraokeAudioProcessor;->readyQueue:Ljava/util/LinkedList;

    invoke-virtual {v5}, Ljava/util/LinkedList;->isEmpty()Z

    move-result v5

    if-eqz v5, :cond_11b

    iget v5, v6, Lradiant/KaraokeAudioProcessor;->generation:I

    if-ne v5, v0, :cond_11b

    invoke-static {}, Lradiant/KaraokeBridge;->isEnabled()Z

    move-result v5

    if-eqz v5, :cond_11b

    .line 273
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v9
    :try_end_105
    .catchall {:try_start_d0 .. :try_end_105} :catchall_12b

    sub-long v9, v7, v9

    .line 274
    cmp-long v5, v9, v3

    if-gtz v5, :cond_10c

    .line 275
    goto :goto_11b

    .line 278
    :cond_10c
    :try_start_10c
    iget-object v5, v6, Lradiant/KaraokeAudioProcessor;->queueLock:Ljava/lang/Object;

    const-wide/16 v11, 0x14

    invoke-static {v11, v12, v9, v10}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v9

    invoke-virtual {v5, v9, v10}, Ljava/lang/Object;->wait(J)V
    :try_end_117
    .catch Ljava/lang/InterruptedException; {:try_start_10c .. :try_end_117} :catch_119
    .catchall {:try_start_10c .. :try_end_117} :catchall_12b

    .line 281
    nop

    .line 282
    goto :goto_ef

    .line 279
    :catch_119
    move-exception v0

    .line 280
    nop

    .line 284
    :cond_11b
    :goto_11b
    :try_start_11b
    iget-object v0, v6, Lradiant/KaraokeAudioProcessor;->readyQueue:Ljava/util/LinkedList;

    invoke-virtual {v0}, Ljava/util/LinkedList;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_125

    .line 285
    iput-boolean v2, v6, Lradiant/KaraokeAudioProcessor;->primed:Z

    .line 287
    :cond_125
    monitor-exit v1
    :try_end_126
    .catchall {:try_start_11b .. :try_end_126} :catchall_12b

    .line 288
    iget-boolean v0, v6, Lradiant/KaraokeAudioProcessor;->primed:Z

    if-nez v0, :cond_12f

    .line 289
    return-void

    .line 287
    :catchall_12b
    move-exception v0

    move-object p1, v0

    :try_start_12d
    monitor-exit v1
    :try_end_12e
    .catchall {:try_start_12d .. :try_end_12e} :catchall_12b

    throw p1

    .line 293
    :cond_12f
    if-lez p1, :cond_134

    .line 294
    invoke-direct {p0, p1}, Lradiant/KaraokeAudioProcessor;->emitWetExactly(I)V

    .line 296
    :cond_134
    return-void
.end method

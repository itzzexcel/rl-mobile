.class Lradiant/KaraokeAudioProcessor$1;
.super Ljava/lang/Object;
.source "KaraokeAudioProcessor.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lradiant/KaraokeAudioProcessor;->ensureWorkerStarted()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lradiant/KaraokeAudioProcessor;


# direct methods
.method constructor <init>(Lradiant/KaraokeAudioProcessor;)V
    .registers 2
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010
        }
        names = {
            null
        }
    .end annotation

    .line 102
    iput-object p1, p0, Lradiant/KaraokeAudioProcessor$1;->this$0:Lradiant/KaraokeAudioProcessor;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 8

    .line 107
    nop

    :goto_1
    iget-object v0, p0, Lradiant/KaraokeAudioProcessor$1;->this$0:Lradiant/KaraokeAudioProcessor;

    invoke-static {v0}, Lradiant/KaraokeAudioProcessor;->-$$Nest$fgetqueueLock(Lradiant/KaraokeAudioProcessor;)Ljava/lang/Object;

    move-result-object v0

    monitor-enter v0

    .line 108
    :goto_8
    :try_start_8
    iget-object v1, p0, Lradiant/KaraokeAudioProcessor$1;->this$0:Lradiant/KaraokeAudioProcessor;

    invoke-static {v1}, Lradiant/KaraokeAudioProcessor;->-$$Nest$fgetpendingQueue(Lradiant/KaraokeAudioProcessor;)Ljava/util/LinkedList;

    move-result-object v1

    invoke-virtual {v1}, Ljava/util/LinkedList;->isEmpty()Z

    move-result v1
    :try_end_12
    .catchall {:try_start_8 .. :try_end_12} :catchall_f5

    if-eqz v1, :cond_21

    .line 110
    :try_start_14
    iget-object v1, p0, Lradiant/KaraokeAudioProcessor$1;->this$0:Lradiant/KaraokeAudioProcessor;

    invoke-static {v1}, Lradiant/KaraokeAudioProcessor;->-$$Nest$fgetqueueLock(Lradiant/KaraokeAudioProcessor;)Ljava/lang/Object;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Object;->wait()V
    :try_end_1d
    .catch Ljava/lang/InterruptedException; {:try_start_14 .. :try_end_1d} :catch_1e
    .catchall {:try_start_14 .. :try_end_1d} :catchall_f5

    .line 113
    goto :goto_8

    .line 111
    :catch_1e
    move-exception v1

    .line 112
    :try_start_1f
    monitor-exit v0

    return-void

    .line 115
    :cond_21
    iget-object v1, p0, Lradiant/KaraokeAudioProcessor$1;->this$0:Lradiant/KaraokeAudioProcessor;

    invoke-static {v1}, Lradiant/KaraokeAudioProcessor;->-$$Nest$fgetpendingQueue(Lradiant/KaraokeAudioProcessor;)Ljava/util/LinkedList;

    move-result-object v1

    invoke-virtual {v1}, Ljava/util/LinkedList;->pollFirst()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lradiant/KaraokeAudioProcessor$PendingChunk;

    .line 116
    iget-object v2, p0, Lradiant/KaraokeAudioProcessor$1;->this$0:Lradiant/KaraokeAudioProcessor;

    const/4 v3, 0x0

    if-eqz v1, :cond_34

    const/4 v4, 0x1

    goto :goto_35

    :cond_34
    move v4, v3

    :goto_35
    invoke-static {v2, v4}, Lradiant/KaraokeAudioProcessor;->-$$Nest$fputworkerBusy(Lradiant/KaraokeAudioProcessor;Z)V

    .line 117
    iget-object v2, p0, Lradiant/KaraokeAudioProcessor$1;->this$0:Lradiant/KaraokeAudioProcessor;

    invoke-static {v2}, Lradiant/KaraokeAudioProcessor;->-$$Nest$fgetqueueLock(Lradiant/KaraokeAudioProcessor;)Ljava/lang/Object;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Object;->notifyAll()V

    .line 118
    monitor-exit v0
    :try_end_42
    .catchall {:try_start_1f .. :try_end_42} :catchall_f5

    .line 119
    if-eqz v1, :cond_da

    iget v0, v1, Lradiant/KaraokeAudioProcessor$PendingChunk;->generation:I

    iget-object v2, p0, Lradiant/KaraokeAudioProcessor$1;->this$0:Lradiant/KaraokeAudioProcessor;

    invoke-static {v2}, Lradiant/KaraokeAudioProcessor;->-$$Nest$fgetgeneration(Lradiant/KaraokeAudioProcessor;)I

    move-result v2

    if-eq v0, v2, :cond_50

    goto/16 :goto_da

    .line 126
    :cond_50
    iget-object v0, v1, Lradiant/KaraokeAudioProcessor$PendingChunk;->mode:Ljava/lang/String;

    iget-object v2, v1, Lradiant/KaraokeAudioProcessor$PendingChunk;->windowDryBytes:[B

    const v4, 0x39200

    const/16 v5, 0x6200

    invoke-static {v0, v2, v4, v5}, Lradiant/KaraokeBridge;->separateHop(Ljava/lang/String;[BII)[B

    move-result-object v0

    .line 130
    if-eqz v0, :cond_95

    array-length v2, v0

    const v4, 0x18800

    if-lt v2, v4, :cond_95

    .line 131
    const v2, 0x18000

    new-array v4, v2, [B

    .line 132
    invoke-static {v0, v3, v4, v3, v2}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 133
    iget-object v5, p0, Lradiant/KaraokeAudioProcessor$1;->this$0:Lradiant/KaraokeAudioProcessor;

    invoke-static {v5}, Lradiant/KaraokeAudioProcessor;->-$$Nest$fgetworkerPrevTailGen(Lradiant/KaraokeAudioProcessor;)I

    move-result v5

    iget v6, v1, Lradiant/KaraokeAudioProcessor$PendingChunk;->generation:I

    if-ne v5, v6, :cond_82

    .line 134
    iget-object v5, p0, Lradiant/KaraokeAudioProcessor$1;->this$0:Lradiant/KaraokeAudioProcessor;

    invoke-static {v5}, Lradiant/KaraokeAudioProcessor;->-$$Nest$fgetworkerPrevTail(Lradiant/KaraokeAudioProcessor;)[B

    move-result-object v5

    const/16 v6, 0x200

    invoke-static {v5, v4, v6}, Lradiant/KaraokeAudioProcessor;->-$$Nest$smcrossfadeInPlace([B[BI)V

    .line 136
    :cond_82
    iget-object v5, p0, Lradiant/KaraokeAudioProcessor$1;->this$0:Lradiant/KaraokeAudioProcessor;

    invoke-static {v5}, Lradiant/KaraokeAudioProcessor;->-$$Nest$fgetworkerPrevTail(Lradiant/KaraokeAudioProcessor;)[B

    move-result-object v5

    const/16 v6, 0x800

    invoke-static {v0, v2, v5, v3, v6}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 137
    iget-object v0, p0, Lradiant/KaraokeAudioProcessor$1;->this$0:Lradiant/KaraokeAudioProcessor;

    iget v2, v1, Lradiant/KaraokeAudioProcessor$PendingChunk;->generation:I

    invoke-static {v0, v2}, Lradiant/KaraokeAudioProcessor;->-$$Nest$fputworkerPrevTailGen(Lradiant/KaraokeAudioProcessor;I)V

    goto :goto_9d

    .line 139
    :cond_95
    iget-object v4, v1, Lradiant/KaraokeAudioProcessor$PendingChunk;->dryHopBytes:[B

    .line 140
    iget-object v0, p0, Lradiant/KaraokeAudioProcessor$1;->this$0:Lradiant/KaraokeAudioProcessor;

    const/4 v2, -0x1

    invoke-static {v0, v2}, Lradiant/KaraokeAudioProcessor;->-$$Nest$fputworkerPrevTailGen(Lradiant/KaraokeAudioProcessor;I)V

    .line 143
    :goto_9d
    iget-object v0, p0, Lradiant/KaraokeAudioProcessor$1;->this$0:Lradiant/KaraokeAudioProcessor;

    invoke-static {v0}, Lradiant/KaraokeAudioProcessor;->-$$Nest$fgetqueueLock(Lradiant/KaraokeAudioProcessor;)Ljava/lang/Object;

    move-result-object v0

    monitor-enter v0

    .line 144
    :try_start_a4
    iget-object v2, p0, Lradiant/KaraokeAudioProcessor$1;->this$0:Lradiant/KaraokeAudioProcessor;

    invoke-static {v2, v3}, Lradiant/KaraokeAudioProcessor;->-$$Nest$fputworkerBusy(Lradiant/KaraokeAudioProcessor;Z)V

    .line 145
    iget v2, v1, Lradiant/KaraokeAudioProcessor$PendingChunk;->generation:I

    iget-object v3, p0, Lradiant/KaraokeAudioProcessor$1;->this$0:Lradiant/KaraokeAudioProcessor;

    invoke-static {v3}, Lradiant/KaraokeAudioProcessor;->-$$Nest$fgetgeneration(Lradiant/KaraokeAudioProcessor;)I

    move-result v3

    if-ne v2, v3, :cond_cb

    invoke-static {}, Lradiant/KaraokeBridge;->isEnabled()Z

    move-result v2

    if-eqz v2, :cond_cb

    .line 146
    iget-object v2, p0, Lradiant/KaraokeAudioProcessor$1;->this$0:Lradiant/KaraokeAudioProcessor;

    invoke-static {v2}, Lradiant/KaraokeAudioProcessor;->-$$Nest$fgetreadyQueue(Lradiant/KaraokeAudioProcessor;)Ljava/util/LinkedList;

    move-result-object v2

    new-instance v3, Lradiant/KaraokeAudioProcessor$ReadyChunk;

    iget v5, v1, Lradiant/KaraokeAudioProcessor$PendingChunk;->generation:I

    iget-object v1, v1, Lradiant/KaraokeAudioProcessor$PendingChunk;->dryHopBytes:[B

    invoke-direct {v3, v5, v1, v4}, Lradiant/KaraokeAudioProcessor$ReadyChunk;-><init>(I[B[B)V

    invoke-virtual {v2, v3}, Ljava/util/LinkedList;->addLast(Ljava/lang/Object;)V

    .line 148
    :cond_cb
    iget-object v1, p0, Lradiant/KaraokeAudioProcessor$1;->this$0:Lradiant/KaraokeAudioProcessor;

    invoke-static {v1}, Lradiant/KaraokeAudioProcessor;->-$$Nest$fgetqueueLock(Lradiant/KaraokeAudioProcessor;)Ljava/lang/Object;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Object;->notifyAll()V

    .line 149
    monitor-exit v0

    .line 150
    goto/16 :goto_1

    .line 149
    :catchall_d7
    move-exception v1

    monitor-exit v0
    :try_end_d9
    .catchall {:try_start_a4 .. :try_end_d9} :catchall_d7

    throw v1

    .line 120
    :cond_da
    :goto_da
    iget-object v0, p0, Lradiant/KaraokeAudioProcessor$1;->this$0:Lradiant/KaraokeAudioProcessor;

    invoke-static {v0}, Lradiant/KaraokeAudioProcessor;->-$$Nest$fgetqueueLock(Lradiant/KaraokeAudioProcessor;)Ljava/lang/Object;

    move-result-object v1

    monitor-enter v1

    .line 121
    :try_start_e1
    iget-object v0, p0, Lradiant/KaraokeAudioProcessor$1;->this$0:Lradiant/KaraokeAudioProcessor;

    invoke-static {v0, v3}, Lradiant/KaraokeAudioProcessor;->-$$Nest$fputworkerBusy(Lradiant/KaraokeAudioProcessor;Z)V

    .line 122
    iget-object v0, p0, Lradiant/KaraokeAudioProcessor$1;->this$0:Lradiant/KaraokeAudioProcessor;

    invoke-static {v0}, Lradiant/KaraokeAudioProcessor;->-$$Nest$fgetqueueLock(Lradiant/KaraokeAudioProcessor;)Ljava/lang/Object;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->notifyAll()V

    .line 123
    monitor-exit v1

    .line 124
    goto/16 :goto_1

    .line 123
    :catchall_f2
    move-exception v0

    monitor-exit v1
    :try_end_f4
    .catchall {:try_start_e1 .. :try_end_f4} :catchall_f2

    throw v0

    .line 118
    :catchall_f5
    move-exception v1

    :try_start_f6
    monitor-exit v0
    :try_end_f7
    .catchall {:try_start_f6 .. :try_end_f7} :catchall_f5

    throw v1
.end method

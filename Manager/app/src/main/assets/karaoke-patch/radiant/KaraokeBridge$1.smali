.class Lradiant/KaraokeBridge$1;
.super Ljava/lang/Object;
.source "KaraokeBridge.java"

# interfaces
.implements Landroid/content/ServiceConnection;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lradiant/KaraokeBridge;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 56
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onServiceConnected(Landroid/content/ComponentName;Landroid/os/IBinder;)V
    .registers 5

    .line 59
    invoke-static {}, Lradiant/KaraokeBridge;->-$$Nest$sfgetLOCK()Ljava/lang/Object;

    move-result-object v0

    monitor-enter v0

    .line 60
    :try_start_5
    invoke-static {p2}, Lradiant/KaraokeBridge;->-$$Nest$sfputserviceBinder(Landroid/os/IBinder;)V

    .line 61
    invoke-static {}, Lradiant/KaraokeBridge;->-$$Nest$sfgetLOCK()Ljava/lang/Object;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/Object;->notifyAll()V

    .line 62
    monitor-exit v0
    :try_end_10
    .catchall {:try_start_5 .. :try_end_10} :catchall_30

    .line 63
    invoke-static {}, Lradiant/KaraokeBridge;->-$$Nest$smqueryStatusAsync()V

    .line 64
    const-string p2, "RLKaraokeBridge"

    invoke-virtual {p1}, Landroid/content/ComponentName;->flattenToShortString()Ljava/lang/String;

    move-result-object p1

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Bound to KaraokeRelayService: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p2, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 65
    return-void

    .line 62
    :catchall_30
    move-exception p1

    :try_start_31
    monitor-exit v0
    :try_end_32
    .catchall {:try_start_31 .. :try_end_32} :catchall_30

    throw p1
.end method

.method public onServiceDisconnected(Landroid/content/ComponentName;)V
    .registers 5

    .line 71
    invoke-static {}, Lradiant/KaraokeBridge;->-$$Nest$sfgetLOCK()Ljava/lang/Object;

    move-result-object p1

    monitor-enter p1

    .line 72
    const/4 v0, 0x0

    :try_start_6
    invoke-static {v0}, Lradiant/KaraokeBridge;->-$$Nest$sfputserviceBinder(Landroid/os/IBinder;)V

    .line 73
    invoke-static {}, Lradiant/KaraokeBridge;->-$$Nest$sfgetenabled()Z

    move-result v0

    if-eqz v0, :cond_17

    invoke-static {}, Lradiant/KaraokeBridge;->-$$Nest$sfgetintentionalUnbind()Z

    move-result v0

    if-nez v0, :cond_17

    const/4 v0, 0x1

    goto :goto_18

    :cond_17
    const/4 v0, 0x0

    .line 74
    :goto_18
    invoke-static {}, Lradiant/KaraokeBridge;->-$$Nest$sfgetboundContext()Landroid/content/Context;

    move-result-object v1

    .line 75
    invoke-static {}, Lradiant/KaraokeBridge;->-$$Nest$sfgetLOCK()Ljava/lang/Object;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Object;->notifyAll()V

    .line 76
    monitor-exit p1
    :try_end_24
    .catchall {:try_start_6 .. :try_end_24} :catchall_3f

    .line 77
    const-string p1, "Idle"

    invoke-static {p1}, Lradiant/KaraokeBridge;->-$$Nest$sfputlastProvider(Ljava/lang/String;)V

    .line 78
    if-eqz v0, :cond_3e

    .line 79
    const-string p1, "RLKaraokeBridge"

    const-string v0, "KaraokeRelayService disconnected unexpectedly; tripping circuit breaker"

    invoke-static {p1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 80
    if-eqz v1, :cond_35

    goto :goto_39

    :cond_35
    invoke-static {}, Lradiant/KaraokeBridge;->-$$Nest$smappContext()Landroid/content/Context;

    move-result-object v1

    :goto_39
    const-string p1, "Karaoke NPU crashed \u2014 auto-disabled"

    invoke-static {v1, p1}, Lradiant/KaraokeBridge;->-$$Nest$smtripCircuitBreaker(Landroid/content/Context;Ljava/lang/String;)V

    .line 83
    :cond_3e
    return-void

    .line 76
    :catchall_3f
    move-exception v0

    :try_start_40
    monitor-exit p1
    :try_end_41
    .catchall {:try_start_40 .. :try_end_41} :catchall_3f

    throw v0
.end method

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

    .line 51
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onServiceConnected(Landroid/content/ComponentName;Landroid/os/IBinder;)V
    .registers 5

    .line 54
    invoke-static {}, Lradiant/KaraokeBridge;->-$$Nest$sfgetLOCK()Ljava/lang/Object;

    move-result-object v0

    monitor-enter v0

    .line 55
    :try_start_5
    invoke-static {p2}, Lradiant/KaraokeBridge;->-$$Nest$sfputserviceBinder(Landroid/os/IBinder;)V

    .line 56
    invoke-static {}, Lradiant/KaraokeBridge;->-$$Nest$sfgetLOCK()Ljava/lang/Object;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/Object;->notifyAll()V

    .line 57
    monitor-exit v0
    :try_end_10
    .catchall {:try_start_5 .. :try_end_10} :catchall_30

    .line 58
    invoke-static {}, Lradiant/KaraokeBridge;->-$$Nest$smqueryStatusAsync()V

    .line 59
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

    .line 60
    return-void

    .line 57
    :catchall_30
    move-exception p1

    :try_start_31
    monitor-exit v0
    :try_end_32
    .catchall {:try_start_31 .. :try_end_32} :catchall_30

    throw p1
.end method

.method public onServiceDisconnected(Landroid/content/ComponentName;)V
    .registers 3

    .line 64
    invoke-static {}, Lradiant/KaraokeBridge;->-$$Nest$sfgetLOCK()Ljava/lang/Object;

    move-result-object p1

    monitor-enter p1

    .line 65
    const/4 v0, 0x0

    :try_start_6
    invoke-static {v0}, Lradiant/KaraokeBridge;->-$$Nest$sfputserviceBinder(Landroid/os/IBinder;)V

    .line 66
    invoke-static {}, Lradiant/KaraokeBridge;->-$$Nest$sfgetLOCK()Ljava/lang/Object;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->notifyAll()V

    .line 67
    monitor-exit p1
    :try_end_11
    .catchall {:try_start_6 .. :try_end_11} :catchall_17

    .line 68
    const-string p1, "Idle"

    invoke-static {p1}, Lradiant/KaraokeBridge;->-$$Nest$sfputlastProvider(Ljava/lang/String;)V

    .line 69
    return-void

    .line 67
    :catchall_17
    move-exception v0

    :try_start_18
    monitor-exit p1
    :try_end_19
    .catchall {:try_start_18 .. :try_end_19} :catchall_17

    throw v0
.end method

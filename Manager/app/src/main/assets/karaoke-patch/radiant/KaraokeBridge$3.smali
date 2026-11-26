.class Lradiant/KaraokeBridge$3;
.super Ljava/lang/Object;
.source "KaraokeBridge.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lradiant/KaraokeBridge;->queryStatusAsync()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 261
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 7

    .line 265
    invoke-static {}, Lradiant/KaraokeBridge;->-$$Nest$sfgetLOCK()Ljava/lang/Object;

    move-result-object v0

    monitor-enter v0

    .line 266
    :try_start_5
    invoke-static {}, Lradiant/KaraokeBridge;->-$$Nest$sfgetserviceBinder()Landroid/os/IBinder;

    move-result-object v1

    .line 267
    monitor-exit v0
    :try_end_a
    .catchall {:try_start_5 .. :try_end_a} :catchall_8f

    .line 268
    if-nez v1, :cond_d

    return-void

    .line 269
    :cond_d
    invoke-static {}, Landroid/os/Parcel;->obtain()Landroid/os/Parcel;

    move-result-object v0

    .line 270
    invoke-static {}, Landroid/os/Parcel;->obtain()Landroid/os/Parcel;

    move-result-object v2

    .line 272
    :try_start_15
    const-string v3, "radiant.karaoke.IRelay"

    invoke-virtual {v0, v3}, Landroid/os/Parcel;->writeInterfaceToken(Ljava/lang/String;)V

    .line 273
    invoke-static {}, Lradiant/KaraokeBridge;->-$$Nest$sfgetmode()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 274
    const/4 v3, 0x0

    const/4 v4, 0x1

    invoke-interface {v1, v4, v0, v2, v3}, Landroid/os/IBinder;->transact(ILandroid/os/Parcel;Landroid/os/Parcel;I)Z

    move-result v1

    if-eqz v1, :cond_61

    .line 275
    invoke-virtual {v2}, Landroid/os/Parcel;->readException()V

    .line 276
    invoke-virtual {v2}, Landroid/os/Parcel;->readInt()I

    move-result v1

    if-eqz v1, :cond_34

    move v1, v4

    goto :goto_35

    :cond_34
    move v1, v3

    :goto_35
    invoke-static {v1}, Lradiant/KaraokeBridge;->-$$Nest$sfputkaraInstalled(Z)V

    .line 277
    invoke-virtual {v2}, Landroid/os/Parcel;->readInt()I

    move-result v1

    if-eqz v1, :cond_3f

    move v3, v4

    :cond_3f
    invoke-static {v3}, Lradiant/KaraokeBridge;->-$$Nest$sfputinstInstalled(Z)V

    .line 278
    invoke-virtual {v2}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v1

    .line 279
    if-eqz v1, :cond_4b

    invoke-static {v1}, Lradiant/KaraokeBridge;->-$$Nest$sfputlastProvider(Ljava/lang/String;)V

    .line 280
    :cond_4b
    invoke-virtual {v2}, Landroid/os/Parcel;->readDouble()D

    move-result-wide v3

    invoke-static {v3, v4}, Lradiant/KaraokeBridge;->-$$Nest$sfputlastMs(D)V

    .line 281
    invoke-virtual {v2}, Landroid/os/Parcel;->readInt()I

    move-result v1

    .line 282
    const/16 v3, 0x1000

    if-lt v1, v3, :cond_61

    const/high16 v3, 0x80000

    if-gt v1, v3, :cond_61

    invoke-static {v1}, Lradiant/KaraokeBridge;->-$$Nest$sfputchunkFrames(I)V
    :try_end_61
    .catchall {:try_start_15 .. :try_end_61} :catchall_68

    .line 287
    :cond_61
    :goto_61
    invoke-virtual {v0}, Landroid/os/Parcel;->recycle()V

    .line 288
    invoke-virtual {v2}, Landroid/os/Parcel;->recycle()V

    .line 289
    goto :goto_86

    .line 284
    :catchall_68
    move-exception v1

    .line 285
    :try_start_69
    const-string v3, "RLKaraokeBridge"

    invoke-virtual {v1}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v1

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Status check error: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v3, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_85
    .catchall {:try_start_69 .. :try_end_85} :catchall_87

    goto :goto_61

    .line 290
    :goto_86
    return-void

    .line 287
    :catchall_87
    move-exception v1

    invoke-virtual {v0}, Landroid/os/Parcel;->recycle()V

    .line 288
    invoke-virtual {v2}, Landroid/os/Parcel;->recycle()V

    .line 289
    throw v1

    .line 267
    :catchall_8f
    move-exception v1

    :try_start_90
    monitor-exit v0
    :try_end_91
    .catchall {:try_start_90 .. :try_end_91} :catchall_8f

    throw v1
.end method

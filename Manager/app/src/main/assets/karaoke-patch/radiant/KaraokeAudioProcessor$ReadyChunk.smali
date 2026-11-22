.class final Lradiant/KaraokeAudioProcessor$ReadyChunk;
.super Ljava/lang/Object;
.source "KaraokeAudioProcessor.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lradiant/KaraokeAudioProcessor;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "ReadyChunk"
.end annotation


# instance fields
.field final dryBytes:[B

.field final generation:I

.field final instBytes:[B


# direct methods
.method constructor <init>(I[B[B)V
    .registers 4

    .line 61
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 62
    iput p1, p0, Lradiant/KaraokeAudioProcessor$ReadyChunk;->generation:I

    .line 63
    iput-object p2, p0, Lradiant/KaraokeAudioProcessor$ReadyChunk;->dryBytes:[B

    .line 64
    iput-object p3, p0, Lradiant/KaraokeAudioProcessor$ReadyChunk;->instBytes:[B

    .line 65
    return-void
.end method

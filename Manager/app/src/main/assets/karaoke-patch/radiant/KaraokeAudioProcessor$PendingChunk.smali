.class final Lradiant/KaraokeAudioProcessor$PendingChunk;
.super Ljava/lang/Object;
.source "KaraokeAudioProcessor.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lradiant/KaraokeAudioProcessor;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "PendingChunk"
.end annotation


# instance fields
.field final dryHopBytes:[B

.field final generation:I

.field final mode:Ljava/lang/String;

.field final windowDryBytes:[B


# direct methods
.method constructor <init>(ILjava/lang/String;[B[B)V
    .registers 5

    .line 48
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 49
    iput p1, p0, Lradiant/KaraokeAudioProcessor$PendingChunk;->generation:I

    .line 50
    iput-object p2, p0, Lradiant/KaraokeAudioProcessor$PendingChunk;->mode:Ljava/lang/String;

    .line 51
    iput-object p3, p0, Lradiant/KaraokeAudioProcessor$PendingChunk;->windowDryBytes:[B

    .line 52
    iput-object p4, p0, Lradiant/KaraokeAudioProcessor$PendingChunk;->dryHopBytes:[B

    .line 53
    return-void
.end method

.class public final Lradiant/KaraokeMicPainter;
.super Landroidx/compose/ui/graphics/painter/Painter;
.source "KaraokeMicPainter.java"


# static fields
.field private static cachedCyan:Lradiant/KaraokeMicPainter;

.field private static cachedInner:Landroidx/compose/ui/graphics/painter/Painter;


# instance fields
.field private final inner:Landroidx/compose/ui/graphics/painter/Painter;

.field private final tintPaint:Landroid/graphics/Paint;


# direct methods
.method private constructor <init>(Landroidx/compose/ui/graphics/painter/Painter;)V
    .registers 4

    .line 25
    invoke-direct {p0}, Landroidx/compose/ui/graphics/painter/Painter;-><init>()V

    .line 23
    new-instance v0, Landroid/graphics/Paint;

    const/4 v1, 0x1

    invoke-direct {v0, v1}, Landroid/graphics/Paint;-><init>(I)V

    iput-object v0, p0, Lradiant/KaraokeMicPainter;->tintPaint:Landroid/graphics/Paint;

    .line 26
    iput-object p1, p0, Lradiant/KaraokeMicPainter;->inner:Landroidx/compose/ui/graphics/painter/Painter;

    .line 27
    iget-object p1, p0, Lradiant/KaraokeMicPainter;->tintPaint:Landroid/graphics/Paint;

    const v0, -0xa11801

    invoke-virtual {p1, v0}, Landroid/graphics/Paint;->setColor(I)V

    .line 28
    iget-object p1, p0, Lradiant/KaraokeMicPainter;->tintPaint:Landroid/graphics/Paint;

    new-instance v0, Landroid/graphics/PorterDuffXfermode;

    sget-object v1, Landroid/graphics/PorterDuff$Mode;->SRC_IN:Landroid/graphics/PorterDuff$Mode;

    invoke-direct {v0, v1}, Landroid/graphics/PorterDuffXfermode;-><init>(Landroid/graphics/PorterDuff$Mode;)V

    invoke-virtual {p1, v0}, Landroid/graphics/Paint;->setXfermode(Landroid/graphics/Xfermode;)Landroid/graphics/Xfermode;

    .line 29
    return-void
.end method

.method public static cyan(Landroidx/compose/ui/graphics/painter/Painter;)Landroidx/compose/ui/graphics/painter/Painter;
    .registers 3

    .line 32
    if-nez p0, :cond_4

    const/4 p0, 0x0

    return-object p0

    .line 33
    :cond_4
    sget-object v0, Lradiant/KaraokeMicPainter;->cachedCyan:Lradiant/KaraokeMicPainter;

    .line 34
    if-eqz v0, :cond_c

    sget-object v1, Lradiant/KaraokeMicPainter;->cachedInner:Landroidx/compose/ui/graphics/painter/Painter;

    if-eq v1, p0, :cond_15

    .line 35
    :cond_c
    sput-object p0, Lradiant/KaraokeMicPainter;->cachedInner:Landroidx/compose/ui/graphics/painter/Painter;

    .line 36
    new-instance v0, Lradiant/KaraokeMicPainter;

    invoke-direct {v0, p0}, Lradiant/KaraokeMicPainter;-><init>(Landroidx/compose/ui/graphics/painter/Painter;)V

    .line 37
    sput-object v0, Lradiant/KaraokeMicPainter;->cachedCyan:Lradiant/KaraokeMicPainter;

    .line 39
    :cond_15
    return-object v0
.end method


# virtual methods
.method public applyColorFilter(Landroidx/compose/ui/graphics/ColorFilter;)Z
    .registers 2

    .line 49
    const/4 p1, 0x1

    return p1
.end method

.method public getIntrinsicSize-NH-jbRc()J
    .registers 3

    .line 44
    iget-object v0, p0, Lradiant/KaraokeMicPainter;->inner:Landroidx/compose/ui/graphics/painter/Painter;

    invoke-virtual {v0}, Landroidx/compose/ui/graphics/painter/Painter;->getIntrinsicSize-NH-jbRc()J

    move-result-wide v0

    return-wide v0
.end method

.method public onDraw(Landroidx/compose/ui/graphics/drawscope/DrawScope;)V
    .registers 13

    .line 54
    invoke-interface {p1}, Landroidx/compose/ui/graphics/drawscope/DrawScope;->getSize-NH-jbRc()J

    move-result-wide v2

    .line 55
    invoke-static {v2, v3}, Landroidx/compose/ui/geometry/Size;->getWidth-impl(J)F

    move-result v7

    .line 56
    invoke-static {v2, v3}, Landroidx/compose/ui/geometry/Size;->getHeight-impl(J)F

    move-result v8

    .line 57
    const/4 v0, 0x0

    cmpg-float v1, v7, v0

    if-lez v1, :cond_3f

    cmpg-float v0, v8, v0

    if-gtz v0, :cond_16

    goto :goto_3f

    .line 58
    :cond_16
    invoke-interface {p1}, Landroidx/compose/ui/graphics/drawscope/DrawScope;->getDrawContext()Landroidx/compose/ui/graphics/drawscope/DrawContext;

    move-result-object v0

    invoke-interface {v0}, Landroidx/compose/ui/graphics/drawscope/DrawContext;->getCanvas()Landroidx/compose/ui/graphics/Canvas;

    move-result-object v0

    invoke-static {v0}, Landroidx/compose/ui/graphics/AndroidCanvas_androidKt;->getNativeCanvas(Landroidx/compose/ui/graphics/Canvas;)Landroid/graphics/Canvas;

    move-result-object v4

    .line 59
    const/4 v6, 0x0

    const/4 v9, 0x0

    const/4 v5, 0x0

    invoke-virtual/range {v4 .. v9}, Landroid/graphics/Canvas;->saveLayer(FFFFLandroid/graphics/Paint;)I

    move-result v10

    .line 60
    move-object v6, v4

    iget-object v0, p0, Lradiant/KaraokeMicPainter;->inner:Landroidx/compose/ui/graphics/painter/Painter;

    const/high16 v4, 0x3f800000    # 1.0f

    const/4 v5, 0x0

    move-object v1, p1

    invoke-virtual/range {v0 .. v5}, Landroidx/compose/ui/graphics/painter/Painter;->draw-x_KDEd0(Landroidx/compose/ui/graphics/drawscope/DrawScope;JFLandroidx/compose/ui/graphics/ColorFilter;)V

    .line 61
    move-object v4, v6

    const/4 v6, 0x0

    iget-object v9, p0, Lradiant/KaraokeMicPainter;->tintPaint:Landroid/graphics/Paint;

    const/4 v5, 0x0

    invoke-virtual/range {v4 .. v9}, Landroid/graphics/Canvas;->drawRect(FFFFLandroid/graphics/Paint;)V

    .line 62
    invoke-virtual {v4, v10}, Landroid/graphics/Canvas;->restoreToCount(I)V

    .line 63
    return-void

    .line 57
    :cond_3f
    :goto_3f
    return-void
.end method

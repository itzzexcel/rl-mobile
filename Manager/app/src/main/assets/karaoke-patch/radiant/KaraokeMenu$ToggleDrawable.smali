.class final Lradiant/KaraokeMenu$ToggleDrawable;
.super Landroid/graphics/drawable/Drawable;
.source "KaraokeMenu.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lradiant/KaraokeMenu;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "ToggleDrawable"
.end annotation


# instance fields
.field private final h:I

.field private final on:Z

.field private final paint:Landroid/graphics/Paint;

.field private final rect:Landroid/graphics/RectF;

.field private final w:I


# direct methods
.method constructor <init>(ZF)V
    .registers 5

    .line 481
    invoke-direct {p0}, Landroid/graphics/drawable/Drawable;-><init>()V

    .line 478
    new-instance v0, Landroid/graphics/Paint;

    const/4 v1, 0x1

    invoke-direct {v0, v1}, Landroid/graphics/Paint;-><init>(I)V

    iput-object v0, p0, Lradiant/KaraokeMenu$ToggleDrawable;->paint:Landroid/graphics/Paint;

    .line 479
    new-instance v0, Landroid/graphics/RectF;

    invoke-direct {v0}, Landroid/graphics/RectF;-><init>()V

    iput-object v0, p0, Lradiant/KaraokeMenu$ToggleDrawable;->rect:Landroid/graphics/RectF;

    .line 482
    iput-boolean p1, p0, Lradiant/KaraokeMenu$ToggleDrawable;->on:Z

    .line 483
    const/high16 p1, 0x42200000    # 40.0f

    mul-float/2addr p1, p2

    invoke-static {p1}, Ljava/lang/Math;->round(F)I

    move-result p1

    iput p1, p0, Lradiant/KaraokeMenu$ToggleDrawable;->w:I

    .line 484
    const/high16 p1, 0x41c00000    # 24.0f

    mul-float/2addr p2, p1

    invoke-static {p2}, Ljava/lang/Math;->round(F)I

    move-result p1

    iput p1, p0, Lradiant/KaraokeMenu$ToggleDrawable;->h:I

    .line 485
    return-void
.end method


# virtual methods
.method public draw(Landroid/graphics/Canvas;)V
    .registers 11

    .line 489
    invoke-virtual {p0}, Lradiant/KaraokeMenu$ToggleDrawable;->getBounds()Landroid/graphics/Rect;

    move-result-object v0

    .line 490
    invoke-virtual {v0}, Landroid/graphics/Rect;->width()I

    move-result v1

    int-to-float v1, v1

    .line 491
    invoke-virtual {v0}, Landroid/graphics/Rect;->height()I

    move-result v2

    int-to-float v2, v2

    .line 492
    const/high16 v3, 0x40000000    # 2.0f

    div-float v3, v2, v3

    .line 493
    iget-object v4, p0, Lradiant/KaraokeMenu$ToggleDrawable;->rect:Landroid/graphics/RectF;

    iget v5, v0, Landroid/graphics/Rect;->left:I

    int-to-float v5, v5

    iget v6, v0, Landroid/graphics/Rect;->top:I

    int-to-float v6, v6

    iget v7, v0, Landroid/graphics/Rect;->left:I

    int-to-float v7, v7

    add-float/2addr v7, v1

    iget v8, v0, Landroid/graphics/Rect;->top:I

    int-to-float v8, v8

    add-float/2addr v8, v2

    invoke-virtual {v4, v5, v6, v7, v8}, Landroid/graphics/RectF;->set(FFFF)V

    .line 494
    iget-object v4, p0, Lradiant/KaraokeMenu$ToggleDrawable;->paint:Landroid/graphics/Paint;

    iget-boolean v5, p0, Lradiant/KaraokeMenu$ToggleDrawable;->on:Z

    const/4 v6, -0x1

    if-eqz v5, :cond_2e

    move v5, v6

    goto :goto_31

    :cond_2e
    const v5, 0x33ffffff

    :goto_31
    invoke-virtual {v4, v5}, Landroid/graphics/Paint;->setColor(I)V

    .line 495
    iget-object v4, p0, Lradiant/KaraokeMenu$ToggleDrawable;->paint:Landroid/graphics/Paint;

    iget-boolean v5, p0, Lradiant/KaraokeMenu$ToggleDrawable;->on:Z

    const/16 v7, 0xff

    if-eqz v5, :cond_3e

    move v5, v7

    goto :goto_40

    :cond_3e
    const/16 v5, 0x33

    :goto_40
    invoke-virtual {v4, v5}, Landroid/graphics/Paint;->setAlpha(I)V

    .line 496
    iget-object v4, p0, Lradiant/KaraokeMenu$ToggleDrawable;->rect:Landroid/graphics/RectF;

    iget-object v5, p0, Lradiant/KaraokeMenu$ToggleDrawable;->paint:Landroid/graphics/Paint;

    invoke-virtual {p1, v4, v3, v3, v5}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V

    .line 497
    const v4, 0x3e19999a    # 0.15f

    mul-float/2addr v2, v4

    .line 498
    sub-float v2, v3, v2

    .line 499
    iget-boolean v4, p0, Lradiant/KaraokeMenu$ToggleDrawable;->on:Z

    if-eqz v4, :cond_5a

    iget v4, v0, Landroid/graphics/Rect;->left:I

    int-to-float v4, v4

    add-float/2addr v4, v1

    sub-float/2addr v4, v3

    goto :goto_5f

    :cond_5a
    iget v1, v0, Landroid/graphics/Rect;->left:I

    int-to-float v1, v1

    add-float v4, v1, v3

    .line 500
    :goto_5f
    iget-object v1, p0, Lradiant/KaraokeMenu$ToggleDrawable;->paint:Landroid/graphics/Paint;

    iget-boolean v5, p0, Lradiant/KaraokeMenu$ToggleDrawable;->on:Z

    if-eqz v5, :cond_67

    const/high16 v6, -0x1000000

    :cond_67
    invoke-virtual {v1, v6}, Landroid/graphics/Paint;->setColor(I)V

    .line 501
    iget-object v1, p0, Lradiant/KaraokeMenu$ToggleDrawable;->paint:Landroid/graphics/Paint;

    iget-boolean v5, p0, Lradiant/KaraokeMenu$ToggleDrawable;->on:Z

    if-eqz v5, :cond_71

    goto :goto_73

    :cond_71
    const/16 v7, 0xcc

    :goto_73
    invoke-virtual {v1, v7}, Landroid/graphics/Paint;->setAlpha(I)V

    .line 502
    iget v0, v0, Landroid/graphics/Rect;->top:I

    int-to-float v0, v0

    add-float/2addr v0, v3

    iget-object v1, p0, Lradiant/KaraokeMenu$ToggleDrawable;->paint:Landroid/graphics/Paint;

    invoke-virtual {p1, v4, v0, v2, v1}, Landroid/graphics/Canvas;->drawCircle(FFFLandroid/graphics/Paint;)V

    .line 503
    return-void
.end method

.method public getIntrinsicHeight()I
    .registers 2

    .line 512
    iget v0, p0, Lradiant/KaraokeMenu$ToggleDrawable;->h:I

    return v0
.end method

.method public getIntrinsicWidth()I
    .registers 2

    .line 507
    iget v0, p0, Lradiant/KaraokeMenu$ToggleDrawable;->w:I

    return v0
.end method

.method public getOpacity()I
    .registers 2

    .line 525
    const/4 v0, -0x3

    return v0
.end method

.method public setAlpha(I)V
    .registers 2

    .line 517
    return-void
.end method

.method public setColorFilter(Landroid/graphics/ColorFilter;)V
    .registers 2

    .line 521
    return-void
.end method

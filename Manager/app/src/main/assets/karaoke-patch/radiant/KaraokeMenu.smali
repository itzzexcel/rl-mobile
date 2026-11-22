.class public final Lradiant/KaraokeMenu;
.super Ljava/lang/Object;
.source "KaraokeMenu.java"

# interfaces
.implements Landroid/view/View$OnClickListener;
.implements Landroid/view/View$OnApplyWindowInsetsListener;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lradiant/KaraokeMenu$ToggleDrawable;,
        Lradiant/KaraokeMenu$VocalSliderListener;
    }
.end annotation


# static fields
.field private static final ACT_NOOP:I = 0x0

.field private static final ACT_SET_MODE:I = 0x2

.field private static final ACT_TOGGLE_ENABLED:I = 0x1

.field private static final INSETS:Lradiant/KaraokeMenu;

.field private static final MODE_LABELS:[Ljava/lang/String;

.field private static final TAG:Ljava/lang/String; = "RLKaraokeMenu"

.field private static dialog:Lcom/google/android/material/bottomsheet/BottomSheetDialog;

.field private static lastOpenMs:J

.field private static list:Landroid/widget/LinearLayout;


# instance fields
.field private final action:I

.field private final arg:I


# direct methods
.method static constructor <clinit>()V
    .registers 4

    .line 48
    const/4 v0, 0x2

    new-array v0, v0, [Ljava/lang/String;

    const-string v1, "KARA_2"

    const/4 v2, 0x0

    aput-object v1, v0, v2

    const/4 v1, 0x1

    const-string v3, "Inst HQ"

    aput-object v3, v0, v1

    sput-object v0, Lradiant/KaraokeMenu;->MODE_LABELS:[Ljava/lang/String;

    .line 50
    new-instance v0, Lradiant/KaraokeMenu;

    invoke-direct {v0, v2, v2}, Lradiant/KaraokeMenu;-><init>(II)V

    sput-object v0, Lradiant/KaraokeMenu;->INSETS:Lradiant/KaraokeMenu;

    return-void
.end method

.method private constructor <init>(II)V
    .registers 3

    .line 59
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 60
    iput p1, p0, Lradiant/KaraokeMenu;->action:I

    .line 61
    iput p2, p0, Lradiant/KaraokeMenu;->arg:I

    .line 62
    return-void
.end method

.method private static buildFallbackHeader(Landroid/content/Context;I)Landroid/view/View;
    .registers 9

    .line 169
    new-instance v0, Landroid/widget/LinearLayout;

    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 170
    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 171
    new-instance v2, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v2}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    .line 172
    invoke-virtual {v2, p1}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    .line 173
    const/16 p1, 0x10

    invoke-static {p0, p1}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result v3

    int-to-float v3, v3

    .line 174
    const/16 v4, 0x8

    new-array v4, v4, [F

    const/4 v5, 0x0

    aput v3, v4, v5

    aput v3, v4, v1

    const/4 v5, 0x2

    aput v3, v4, v5

    const/4 v6, 0x3

    aput v3, v4, v6

    const/4 v3, 0x4

    const/4 v6, 0x0

    aput v6, v4, v3

    const/4 v3, 0x5

    aput v6, v4, v3

    const/4 v3, 0x6

    aput v6, v4, v3

    const/4 v3, 0x7

    aput v6, v4, v3

    invoke-virtual {v2, v4}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadii([F)V

    .line 175
    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 177
    new-instance v2, Landroid/widget/LinearLayout;

    invoke-direct {v2, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 178
    invoke-virtual {v2, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 179
    const/16 v3, 0x14

    invoke-static {p0, v3}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result v3

    .line 180
    invoke-static {p0, p1}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result p1

    const/16 v4, 0xe

    invoke-static {p0, v4}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result v4

    invoke-virtual {v2, v3, p1, v3, v4}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 182
    new-instance p1, Landroid/widget/TextView;

    invoke-direct {p1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 183
    const-string v3, "Karaoke"

    invoke-virtual {p1, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 184
    const/4 v3, -0x1

    invoke-virtual {p1, v3}, Landroid/widget/TextView;->setTextColor(I)V

    .line 185
    const/high16 v4, 0x41880000    # 17.0f

    invoke-virtual {p1, v4}, Landroid/widget/TextView;->setTextSize(F)V

    .line 186
    sget-object v4, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {p1, v4}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    .line 187
    invoke-virtual {v2, p1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 189
    new-instance p1, Landroid/widget/TextView;

    invoke-direct {p1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 190
    const-string v4, "Accelerated by Qualcomm\u00ae Hexagon\u2122 NPU"

    invoke-virtual {p1, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 191
    const v4, -0x7f000001

    invoke-virtual {p1, v4}, Landroid/widget/TextView;->setTextColor(I)V

    .line 192
    const/high16 v4, 0x41400000    # 12.0f

    invoke-virtual {p1, v4}, Landroid/widget/TextView;->setTextSize(F)V

    .line 193
    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v6, -0x2

    invoke-direct {v4, v6, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 195
    invoke-static {p0, v5}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result v5

    iput v5, v4, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    .line 196
    invoke-virtual {v2, p1, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 198
    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 200
    new-instance p1, Landroid/view/View;

    invoke-direct {p1, p0}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 201
    const v2, 0x14ffffff

    invoke-virtual {p1, v2}, Landroid/view/View;->setBackgroundColor(I)V

    .line 202
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;

    .line 203
    invoke-static {p0, v1}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result p0

    invoke-static {v1, p0}, Ljava/lang/Math;->max(II)I

    move-result p0

    invoke-direct {v2, v3, p0}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 202
    invoke-virtual {v0, p1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 204
    return-object v0
.end method

.method private static dp(Landroid/content/Context;I)I
    .registers 2

    .line 467
    int-to-float p1, p1

    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    iget p0, p0, Landroid/util/DisplayMetrics;->density:F

    mul-float/2addr p1, p0

    invoke-static {p1}, Ljava/lang/Math;->round(F)I

    move-result p0

    return p0
.end method

.method private static drawable(Landroid/content/Context;Ljava/lang/String;)Landroid/graphics/drawable/Drawable;
    .registers 3

    .line 456
    const-string v0, "drawable"

    invoke-static {p0, p1, v0}, Lradiant/KaraokeMenu;->res(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)I

    move-result p1

    .line 457
    if-nez p1, :cond_e

    .line 458
    const-string p1, "ic_music_note"

    invoke-static {p0, p1, v0}, Lradiant/KaraokeMenu;->res(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)I

    move-result p1

    .line 460
    :cond_e
    const/4 v0, 0x0

    if-nez p1, :cond_12

    goto :goto_16

    :cond_12
    :try_start_12
    invoke-virtual {p0, p1}, Landroid/content/Context;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0
    :try_end_16
    .catchall {:try_start_12 .. :try_end_16} :catchall_17

    :goto_16
    return-object v0

    .line 461
    :catchall_17
    move-exception p0

    .line 462
    return-object v0
.end method

.method private static findActivity(Landroid/view/View;)Landroid/app/Activity;
    .registers 3

    .line 83
    const/4 v0, 0x0

    if-nez p0, :cond_5

    move-object p0, v0

    goto :goto_9

    :cond_5
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    .line 84
    :goto_9
    instance-of v1, p0, Landroid/content/ContextWrapper;

    if-eqz v1, :cond_1b

    .line 85
    instance-of v1, p0, Landroid/app/Activity;

    if-eqz v1, :cond_14

    .line 86
    check-cast p0, Landroid/app/Activity;

    return-object p0

    .line 87
    :cond_14
    check-cast p0, Landroid/content/ContextWrapper;

    invoke-virtual {p0}, Landroid/content/ContextWrapper;->getBaseContext()Landroid/content/Context;

    move-result-object p0

    goto :goto_9

    .line 89
    :cond_1b
    return-object v0
.end method

.method public static open(Landroid/view/View;)V
    .registers 7

    .line 65
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    .line 66
    sget-wide v2, Lradiant/KaraokeMenu;->lastOpenMs:J

    sub-long v2, v0, v2

    const-wide/16 v4, 0x1f4

    cmp-long v2, v2, v4

    if-gez v2, :cond_f

    .line 67
    return-void

    .line 68
    :cond_f
    sput-wide v0, Lradiant/KaraokeMenu;->lastOpenMs:J

    .line 69
    sget-object v0, Lradiant/KaraokeMenu;->dialog:Lcom/google/android/material/bottomsheet/BottomSheetDialog;

    if-eqz v0, :cond_1e

    sget-object v0, Lradiant/KaraokeMenu;->dialog:Lcom/google/android/material/bottomsheet/BottomSheetDialog;

    invoke-virtual {v0}, Lcom/google/android/material/bottomsheet/BottomSheetDialog;->isShowing()Z

    move-result v0

    if-eqz v0, :cond_1e

    .line 70
    return-void

    .line 72
    :cond_1e
    invoke-static {p0}, Lradiant/KaraokeMenu;->findActivity(Landroid/view/View;)Landroid/app/Activity;

    move-result-object p0

    .line 73
    if-eqz p0, :cond_38

    invoke-virtual {p0}, Landroid/app/Activity;->isFinishing()Z

    move-result v0

    if-eqz v0, :cond_2b

    goto :goto_38

    .line 76
    :cond_2b
    :try_start_2b
    invoke-static {p0}, Lradiant/KaraokeMenu;->show(Landroid/app/Activity;)V
    :try_end_2e
    .catchall {:try_start_2b .. :try_end_2e} :catchall_2f

    .line 79
    goto :goto_37

    .line 77
    :catchall_2f
    move-exception p0

    .line 78
    const-string v0, "RLKaraokeMenu"

    const-string v1, "Failed opening KaraokeMenu"

    invoke-static {v0, v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 80
    :goto_37
    return-void

    .line 74
    :cond_38
    :goto_38
    return-void
.end method

.method private static refresh()V
    .registers 9

    .line 208
    sget-object v0, Lradiant/KaraokeMenu;->list:Landroid/widget/LinearLayout;

    .line 209
    if-nez v0, :cond_5

    .line 210
    return-void

    .line 211
    :cond_5
    invoke-virtual {v0}, Landroid/widget/LinearLayout;->removeAllViews()V

    .line 212
    invoke-virtual {v0}, Landroid/widget/LinearLayout;->getContext()Landroid/content/Context;

    move-result-object v1

    .line 214
    invoke-static {}, Lradiant/KaraokeBridge;->isEnabled()Z

    move-result v2

    .line 215
    const-string v3, "instrumental"

    invoke-static {}, Lradiant/KaraokeBridge;->getMode()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    .line 216
    invoke-static {}, Lradiant/KaraokeBridge;->getVocalGain()F

    move-result v4

    .line 219
    if-nez v2, :cond_23

    .line 220
    const-string v5, "Idle \u00b7 0 MB"

    goto :goto_62

    .line 222
    :cond_23
    invoke-static {}, Lradiant/KaraokeBridge;->getLastMs()D

    move-result-wide v5

    .line 223
    const-wide/16 v7, 0x0

    cmpl-double v7, v5, v7

    if-lez v7, :cond_4b

    invoke-static {v5, v6}, Ljava/lang/Math;->round(D)J

    move-result-wide v5

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, " \u00b7 "

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, " ms"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    goto :goto_4d

    :cond_4b
    const-string v5, ""

    .line 224
    :goto_4d
    invoke-static {}, Lradiant/KaraokeBridge;->getLastProvider()Ljava/lang/String;

    move-result-object v6

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    .line 227
    :goto_62
    const-string v6, "ic_objects_mic_large"

    const-string v7, "Karaoke"

    const/4 v8, 0x1

    invoke-static {v0, v6, v7, v2, v8}, Lradiant/KaraokeMenu;->toggleRow(Landroid/view/ViewGroup;Ljava/lang/String;Ljava/lang/String;ZI)Landroid/view/View;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 228
    sget-object v2, Lradiant/KaraokeMenu;->MODE_LABELS:[Ljava/lang/String;

    const/4 v6, 0x2

    const-string v7, "ic_media_music_note_large"

    invoke-static {v0, v7, v2, v3, v6}, Lradiant/KaraokeMenu;->segmentedRow(Landroid/view/ViewGroup;Ljava/lang/String;[Ljava/lang/String;II)Landroid/view/View;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 229
    const-string v2, "ic_objects_mic_medium"

    invoke-static {v0, v2, v4}, Lradiant/KaraokeMenu;->vocalSliderRow(Landroid/view/ViewGroup;Ljava/lang/String;F)Landroid/view/View;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 231
    new-instance v2, Landroid/view/View;

    invoke-direct {v2, v1}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 232
    const v3, 0x14ffffff

    invoke-virtual {v2, v3}, Landroid/view/View;->setBackgroundColor(I)V

    .line 233
    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    .line 234
    invoke-static {v1, v8}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result v4

    invoke-static {v8, v4}, Ljava/lang/Math;->max(II)I

    move-result v4

    const/4 v6, -0x1

    invoke-direct {v3, v6, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 235
    const/16 v4, 0x10

    invoke-static {v1, v4}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result v6

    const/4 v7, 0x4

    invoke-static {v1, v7}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result v8

    invoke-static {v1, v4}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result v4

    invoke-static {v1, v7}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result v1

    invoke-virtual {v3, v6, v8, v4, v1}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V

    .line 236
    invoke-virtual {v0, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 238
    const-string v1, "ic_music_note"

    const-string v2, "Hexagon NPU"

    invoke-static {v0, v1, v2, v5}, Lradiant/KaraokeMenu;->statusRow(Landroid/view/ViewGroup;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/view/View;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 239
    return-void
.end method

.method private static res(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)I
    .registers 5

    .line 445
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    .line 448
    :try_start_4
    sget v1, Lcom/aspiro/wamp/R$drawable;->ic_music_note:I

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getResourcePackageName(I)Ljava/lang/String;

    move-result-object p0
    :try_end_a
    .catchall {:try_start_4 .. :try_end_a} :catchall_b

    .line 451
    goto :goto_10

    .line 449
    :catchall_b
    move-exception v1

    .line 450
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object p0

    .line 452
    :goto_10
    invoke-virtual {v0, p1, p2, p0}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result p0

    return p0
.end method

.method private static row(Landroid/view/ViewGroup;Ljava/lang/String;Ljava/lang/CharSequence;III)Landroid/view/View;
    .registers 11

    .line 243
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 244
    invoke-static {v0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v1

    const-string v2, "context_menu_item"

    const-string v3, "layout"

    invoke-static {v0, v2, v3}, Lradiant/KaraokeMenu;->res(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)I

    move-result v2

    const/4 v3, 0x0

    invoke-virtual {v1, v2, p0, v3}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;Z)Landroid/view/View;

    move-result-object p0

    .line 245
    const-string v1, "icon"

    const-string v2, "id"

    invoke-static {v0, v1, v2}, Lradiant/KaraokeMenu;->res(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)I

    move-result v1

    invoke-virtual {p0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/ImageView;

    .line 246
    const-string v4, "title"

    invoke-static {v0, v4, v2}, Lradiant/KaraokeMenu;->res(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)I

    move-result v2

    invoke-virtual {p0, v2}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v2

    check-cast v2, Landroid/widget/TextView;

    .line 247
    if-eqz v1, :cond_54

    .line 248
    invoke-static {v0, p1}, Lradiant/KaraokeMenu;->drawable(Landroid/content/Context;Ljava/lang/String;)Landroid/graphics/drawable/Drawable;

    move-result-object p1

    .line 249
    if-eqz p1, :cond_54

    .line 250
    invoke-virtual {p1}, Landroid/graphics/drawable/Drawable;->mutate()Landroid/graphics/drawable/Drawable;

    move-result-object p1

    .line 251
    invoke-virtual {p1, p4}, Landroid/graphics/drawable/Drawable;->setTint(I)V

    .line 252
    invoke-virtual {v1, p1}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 253
    const/16 p1, 0x18

    invoke-static {v0, p1}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result p1

    .line 254
    invoke-virtual {v1}, Landroid/widget/ImageView;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p4

    .line 255
    if-eqz p4, :cond_54

    .line 256
    iput p1, p4, Landroid/view/ViewGroup$LayoutParams;->width:I

    .line 257
    iput p1, p4, Landroid/view/ViewGroup$LayoutParams;->height:I

    .line 258
    invoke-virtual {v1, p4}, Landroid/widget/ImageView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 262
    :cond_54
    if-eqz v2, :cond_5c

    .line 263
    invoke-virtual {v2, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 264
    invoke-virtual {v2, p3}, Landroid/widget/TextView;->setTextColor(I)V

    .line 266
    :cond_5c
    const/4 p1, 0x1

    if-eqz p5, :cond_61

    move p2, p1

    goto :goto_62

    :cond_61
    move p2, v3

    :goto_62
    invoke-virtual {p0, p2}, Landroid/view/View;->setEnabled(Z)V

    .line 267
    if-eqz p5, :cond_68

    goto :goto_69

    :cond_68
    move p1, v3

    :goto_69
    invoke-virtual {p0, p1}, Landroid/view/View;->setClickable(Z)V

    .line 268
    if-eqz p5, :cond_74

    new-instance p1, Lradiant/KaraokeMenu;

    invoke-direct {p1, p5, v3}, Lradiant/KaraokeMenu;-><init>(II)V

    goto :goto_75

    :cond_74
    const/4 p1, 0x0

    :goto_75
    invoke-virtual {p0, p1}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 269
    return-object p0
.end method

.method private static segmentedRow(Landroid/view/ViewGroup;Ljava/lang/String;[Ljava/lang/String;II)Landroid/view/View;
    .registers 13

    .line 282
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 283
    const/4 v5, -0x1

    const/4 v6, 0x0

    const-string v3, ""

    const/4 v4, -0x1

    move-object v1, p0

    move-object v2, p1

    invoke-static/range {v1 .. v6}, Lradiant/KaraokeMenu;->row(Landroid/view/ViewGroup;Ljava/lang/String;Ljava/lang/CharSequence;III)Landroid/view/View;

    move-result-object p0

    .line 284
    new-instance p1, Landroid/widget/FrameLayout;

    invoke-direct {p1, v0}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    .line 285
    invoke-virtual {p0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v1

    .line 286
    if-eqz v1, :cond_21

    iget v2, v1, Landroid/view/ViewGroup$LayoutParams;->height:I

    if-lez v2, :cond_21

    iget v1, v1, Landroid/view/ViewGroup$LayoutParams;->height:I

    goto :goto_27

    :cond_21
    const/16 v1, 0x38

    invoke-static {v0, v1}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result v1

    .line 287
    :goto_27
    new-instance v2, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v3, -0x1

    invoke-direct {v2, v3, v1}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p1, p0, v2}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 289
    new-instance p0, Landroid/widget/LinearLayout;

    invoke-direct {p0, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 290
    const/4 v2, 0x0

    invoke-virtual {p0, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 291
    new-instance v4, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v4}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    .line 292
    const/16 v5, 0xa

    invoke-static {v0, v5}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result v5

    int-to-float v5, v5

    invoke-virtual {v4, v5}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    .line 293
    const v5, 0x1fffffff

    invoke-virtual {v4, v5}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    .line 294
    invoke-virtual {p0, v4}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 295
    const/4 v4, 0x3

    invoke-static {v0, v4}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result v4

    .line 296
    invoke-virtual {p0, v4, v4, v4, v4}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 298
    move v4, v2

    :goto_5a
    array-length v5, p2

    if-ge v4, v5, :cond_ae

    .line 299
    new-instance v5, Landroid/widget/TextView;

    invoke-direct {v5, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 300
    aget-object v6, p2, v4

    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 301
    const/16 v6, 0x11

    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setGravity(I)V

    .line 302
    const/high16 v6, 0x41500000    # 13.0f

    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextSize(F)V

    .line 303
    sget-object v6, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    .line 304
    if-ne v4, p3, :cond_93

    .line 305
    new-instance v6, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v6}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    .line 306
    const/16 v7, 0x8

    invoke-static {v0, v7}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result v7

    int-to-float v7, v7

    invoke-virtual {v6, v7}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    .line 307
    invoke-virtual {v6, v3}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    .line 308
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 309
    const/high16 v6, -0x1000000

    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextColor(I)V

    .line 310
    goto :goto_99

    .line 311
    :cond_93
    const v6, -0x4c000001

    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextColor(I)V

    .line 313
    :goto_99
    new-instance v6, Lradiant/KaraokeMenu;

    invoke-direct {v6, p4, v4}, Lradiant/KaraokeMenu;-><init>(II)V

    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 314
    new-instance v6, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v6, v2, v3, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {p0, v5, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 298
    add-int/lit8 v4, v4, 0x1

    goto :goto_5a

    .line 317
    :cond_ae
    new-instance p2, Landroid/widget/FrameLayout$LayoutParams;

    .line 318
    const/16 p3, 0x24

    invoke-static {v0, p3}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result p3

    const/16 p4, 0x10

    invoke-direct {p2, v3, p3, p4}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    .line 319
    const/16 p3, 0x48

    invoke-static {v0, p3}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result p3

    invoke-virtual {p2, p3}, Landroid/widget/FrameLayout$LayoutParams;->setMarginStart(I)V

    .line 320
    invoke-static {v0, p4}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result p3

    invoke-virtual {p2, p3}, Landroid/widget/FrameLayout$LayoutParams;->setMarginEnd(I)V

    .line 321
    invoke-virtual {p1, p0, p2}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 322
    new-instance p0, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {p0, v3, v1}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p1, p0}, Landroid/widget/FrameLayout;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 323
    return-object p1
.end method

.method private static show(Landroid/app/Activity;)V
    .registers 15

    .line 93
    new-instance v0, Lcom/google/android/material/bottomsheet/BottomSheetDialog;

    const-string v1, "BottomSheetDialogTheme"

    const-string v2, "style"

    invoke-static {p0, v1, v2}, Lradiant/KaraokeMenu;->res(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)I

    move-result v1

    invoke-direct {v0, p0, v1}, Lcom/google/android/material/bottomsheet/BottomSheetDialog;-><init>(Landroid/content/Context;I)V

    .line 94
    invoke-virtual {v0}, Lcom/google/android/material/bottomsheet/BottomSheetDialog;->getContext()Landroid/content/Context;

    move-result-object p0

    .line 95
    invoke-static {p0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v1

    .line 96
    const-string v2, "bottom_sheet_context_menu_dialog"

    const-string v3, "layout"

    invoke-static {p0, v2, v3}, Lradiant/KaraokeMenu;->res(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)I

    move-result v2

    const/4 v3, 0x0

    invoke-virtual {v1, v2, v3}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/view/ViewGroup;

    .line 97
    const-string v2, "headerContainer"

    const-string v4, "id"

    invoke-static {p0, v2, v4}, Lradiant/KaraokeMenu;->res(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)I

    move-result v2

    .line 98
    invoke-virtual {v1, v2}, Landroid/view/ViewGroup;->findViewById(I)Landroid/view/View;

    move-result-object v5

    .line 99
    const-string v6, "recyclerView"

    invoke-static {p0, v6, v4}, Lradiant/KaraokeMenu;->res(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)I

    move-result v4

    invoke-virtual {v1, v4}, Landroid/view/ViewGroup;->findViewById(I)Landroid/view/View;

    move-result-object v4

    .line 100
    if-nez v4, :cond_3e

    move-object v6, v3

    goto :goto_42

    :cond_3e
    invoke-virtual {v4}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;

    move-result-object v6

    .line 102
    :goto_42
    instance-of v7, v5, Landroid/widget/FrameLayout;

    const v8, -0xebebec    # -1.9683E38f

    const/4 v9, 0x0

    const/4 v10, 0x1

    if-eqz v7, :cond_a9

    .line 103
    check-cast v5, Landroid/widget/FrameLayout;

    .line 104
    nop

    .line 106
    :try_start_4e
    const-string v7, "radiant.RLLyrics"

    invoke-static {v7}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v7

    .line 107
    const-string v11, "track"

    invoke-virtual {v7, v11}, Ljava/lang/Class;->getField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v7

    invoke-virtual {v7, v3}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    .line 108
    if-eqz v3, :cond_88

    .line 109
    const-string v7, "com.aspiro.wamp.model.Track"

    invoke-static {v7}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v7

    .line 110
    const-string v11, "com.aspiro.wamp.contextmenu.presentation.header.track.BottomSheetTrackHeader"

    invoke-static {v11}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v11

    .line 112
    const/4 v12, 0x2

    new-array v12, v12, [Ljava/lang/Class;

    const-class v13, Landroid/content/Context;

    aput-object v13, v12, v9

    aput-object v7, v12, v10

    invoke-virtual {v11, v12}, Ljava/lang/Class;->getConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v7

    filled-new-array {p0, v3}, [Ljava/lang/Object;

    move-result-object v3

    .line 113
    invoke-virtual {v7, v3}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/view/View;

    .line 114
    invoke-virtual {v5, v3}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;)V
    :try_end_86
    .catchall {:try_start_4e .. :try_end_86} :catchall_8a

    .line 115
    move v3, v10

    goto :goto_89

    .line 108
    :cond_88
    move v3, v9

    .line 119
    :goto_89
    goto :goto_93

    .line 117
    :catchall_8a
    move-exception v3

    .line 118
    const-string v7, "RLKaraokeMenu"

    const-string v11, "Using fallback Karaoke header"

    invoke-static {v7, v11, v3}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    move v3, v9

    .line 120
    :goto_93
    if-nez v3, :cond_a9

    .line 121
    instance-of v3, v6, Landroid/graphics/drawable/ColorDrawable;

    if-eqz v3, :cond_a1

    .line 122
    move-object v3, v6

    check-cast v3, Landroid/graphics/drawable/ColorDrawable;

    invoke-virtual {v3}, Landroid/graphics/drawable/ColorDrawable;->getColor()I

    move-result v3

    goto :goto_a2

    .line 123
    :cond_a1
    move v3, v8

    .line 124
    :goto_a2
    invoke-static {p0, v3}, Lradiant/KaraokeMenu;->buildFallbackHeader(Landroid/content/Context;I)Landroid/view/View;

    move-result-object v3

    invoke-virtual {v5, v3}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;)V

    .line 128
    :cond_a9
    new-instance v3, Landroid/widget/ScrollView;

    invoke-direct {v3, p0}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V

    .line 129
    invoke-virtual {v3, v10}, Landroid/widget/ScrollView;->setNestedScrollingEnabled(Z)V

    .line 130
    invoke-virtual {v3, v9}, Landroid/widget/ScrollView;->setClipToPadding(Z)V

    .line 131
    if-eqz v6, :cond_c8

    invoke-virtual {v6}, Landroid/graphics/drawable/Drawable;->getConstantState()Landroid/graphics/drawable/Drawable$ConstantState;

    move-result-object v5

    if-eqz v5, :cond_c8

    .line 132
    invoke-virtual {v6}, Landroid/graphics/drawable/Drawable;->getConstantState()Landroid/graphics/drawable/Drawable$ConstantState;

    move-result-object v5

    invoke-virtual {v5}, Landroid/graphics/drawable/Drawable$ConstantState;->newDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object v5

    invoke-virtual {v3, v5}, Landroid/widget/ScrollView;->setBackground(Landroid/graphics/drawable/Drawable;)V

    goto :goto_cb

    .line 134
    :cond_c8
    invoke-virtual {v3, v8}, Landroid/widget/ScrollView;->setBackgroundColor(I)V

    .line 136
    :goto_cb
    if-eqz v4, :cond_d2

    .line 137
    const/16 v5, 0x8

    invoke-virtual {v4, v5}, Landroid/view/View;->setVisibility(I)V

    .line 139
    :cond_d2
    new-instance v4, Landroid/widget/LinearLayout;

    invoke-direct {v4, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 140
    invoke-virtual {v4, v10}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 141
    new-instance p0, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v5, -0x1

    const/4 v6, -0x2

    invoke-direct {p0, v5, v6}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v3, v4, p0}, Landroid/widget/ScrollView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 144
    new-instance p0, Landroid/widget/RelativeLayout$LayoutParams;

    invoke-direct {p0, v5, v6}, Landroid/widget/RelativeLayout$LayoutParams;-><init>(II)V

    .line 146
    const/4 v5, 0x3

    invoke-virtual {p0, v5, v2}, Landroid/widget/RelativeLayout$LayoutParams;->addRule(II)V

    .line 147
    invoke-virtual {v1, v3, p0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 148
    sget-object p0, Lradiant/KaraokeMenu;->INSETS:Lradiant/KaraokeMenu;

    invoke-virtual {v3, p0}, Landroid/widget/ScrollView;->setOnApplyWindowInsetsListener(Landroid/view/View$OnApplyWindowInsetsListener;)V

    .line 150
    invoke-virtual {v0, v1}, Lcom/google/android/material/bottomsheet/BottomSheetDialog;->setContentView(Landroid/view/View;)V

    .line 151
    invoke-virtual {v1}, Landroid/view/ViewGroup;->getParent()Landroid/view/ViewParent;

    move-result-object p0

    instance-of p0, p0, Landroid/view/View;

    if-eqz p0, :cond_109

    .line 152
    invoke-virtual {v1}, Landroid/view/ViewGroup;->getParent()Landroid/view/ViewParent;

    move-result-object p0

    check-cast p0, Landroid/view/View;

    invoke-virtual {p0, v9}, Landroid/view/View;->setBackgroundColor(I)V

    .line 155
    :cond_109
    :try_start_109
    invoke-virtual {v0}, Lcom/google/android/material/bottomsheet/BottomSheetDialog;->getBehavior()Lcom/google/android/material/bottomsheet/BottomSheetBehavior;

    move-result-object p0

    .line 156
    invoke-virtual {p0, v10}, Lcom/google/android/material/bottomsheet/BottomSheetBehavior;->setSkipCollapsed(Z)V

    .line 157
    invoke-virtual {p0, v5}, Lcom/google/android/material/bottomsheet/BottomSheetBehavior;->setState(I)V
    :try_end_113
    .catchall {:try_start_109 .. :try_end_113} :catchall_114

    .line 159
    goto :goto_115

    .line 158
    :catchall_114
    move-exception p0

    .line 161
    :goto_115
    sput-object v0, Lradiant/KaraokeMenu;->dialog:Lcom/google/android/material/bottomsheet/BottomSheetDialog;

    .line 162
    sput-object v4, Lradiant/KaraokeMenu;->list:Landroid/widget/LinearLayout;

    .line 163
    invoke-static {}, Lradiant/KaraokeMenu;->refresh()V

    .line 164
    invoke-virtual {v0}, Lcom/google/android/material/bottomsheet/BottomSheetDialog;->show()V

    .line 165
    invoke-virtual {v3}, Landroid/widget/ScrollView;->requestApplyInsets()V

    .line 166
    return-void
.end method

.method private static statusRow(Landroid/view/ViewGroup;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/view/View;
    .registers 11

    .line 393
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 394
    const v5, -0x66000001

    const/4 v6, 0x0

    const v4, -0x4c000001

    move-object v1, p0

    move-object v2, p1

    move-object v3, p2

    invoke-static/range {v1 .. v6}, Lradiant/KaraokeMenu;->row(Landroid/view/ViewGroup;Ljava/lang/String;Ljava/lang/CharSequence;III)Landroid/view/View;

    move-result-object p0

    .line 395
    new-instance p1, Landroid/widget/TextView;

    invoke-direct {p1, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 396
    invoke-virtual {p1, p3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 397
    const p2, -0x66000001

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setTextColor(I)V

    .line 398
    const/high16 p2, 0x41500000    # 13.0f

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setTextSize(F)V

    .line 399
    invoke-static {v1, p0, p1}, Lradiant/KaraokeMenu;->wrapEnd(Landroid/view/ViewGroup;Landroid/view/View;Landroid/view/View;)Landroid/view/View;

    move-result-object p0

    return-object p0
.end method

.method private static toggleRow(Landroid/view/ViewGroup;Ljava/lang/String;Ljava/lang/String;ZI)Landroid/view/View;
    .registers 12

    .line 273
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 274
    const/4 v4, -0x1

    const/4 v5, -0x1

    move-object v1, p0

    move-object v2, p1

    move-object v3, p2

    move v6, p4

    invoke-static/range {v1 .. v6}, Lradiant/KaraokeMenu;->row(Landroid/view/ViewGroup;Ljava/lang/String;Ljava/lang/CharSequence;III)Landroid/view/View;

    move-result-object p0

    .line 275
    new-instance p1, Landroid/widget/ImageView;

    invoke-direct {p1, v0}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    .line 276
    new-instance p2, Lradiant/KaraokeMenu$ToggleDrawable;

    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p4

    invoke-virtual {p4}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p4

    iget p4, p4, Landroid/util/DisplayMetrics;->density:F

    invoke-direct {p2, p3, p4}, Lradiant/KaraokeMenu$ToggleDrawable;-><init>(ZF)V

    invoke-virtual {p1, p2}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 277
    invoke-static {v1, p0, p1}, Lradiant/KaraokeMenu;->wrapEnd(Landroid/view/ViewGroup;Landroid/view/View;Landroid/view/View;)Landroid/view/View;

    move-result-object p0

    return-object p0
.end method

.method private static vocalSliderRow(Landroid/view/ViewGroup;Ljava/lang/String;F)Landroid/view/View;
    .registers 15

    .line 327
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 328
    const/16 v1, 0x44

    invoke-static {v0, v1}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result v1

    .line 329
    const/4 v6, -0x1

    const/4 v7, 0x0

    const-string v4, ""

    const/4 v5, -0x1

    move-object v2, p0

    move-object v3, p1

    invoke-static/range {v2 .. v7}, Lradiant/KaraokeMenu;->row(Landroid/view/ViewGroup;Ljava/lang/String;Ljava/lang/CharSequence;III)Landroid/view/View;

    move-result-object p0

    .line 330
    new-instance p1, Landroid/widget/FrameLayout;

    invoke-direct {p1, v0}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    .line 331
    new-instance v2, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v3, -0x1

    invoke-direct {v2, v3, v1}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p1, p0, v2}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 333
    new-instance p0, Landroid/widget/LinearLayout;

    invoke-direct {p0, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 334
    const/4 v2, 0x1

    invoke-virtual {p0, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 336
    new-instance v4, Landroid/widget/LinearLayout;

    invoke-direct {v4, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 337
    const/4 v5, 0x0

    invoke-virtual {v4, v5}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 338
    const/16 v6, 0x10

    invoke-virtual {v4, v6}, Landroid/widget/LinearLayout;->setGravity(I)V

    .line 340
    new-instance v7, Landroid/widget/TextView;

    invoke-direct {v7, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 341
    const-string v8, "Vocals"

    invoke-virtual {v7, v8}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 342
    invoke-virtual {v7, v3}, Landroid/widget/TextView;->setTextColor(I)V

    .line 343
    const/high16 v8, 0x41600000    # 14.0f

    invoke-virtual {v7, v8}, Landroid/widget/TextView;->setTextSize(F)V

    .line 344
    new-instance v8, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v9, 0x3f800000    # 1.0f

    const/4 v10, -0x2

    invoke-direct {v8, v5, v10, v9}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v4, v7, v8}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 347
    const/high16 v7, 0x42c80000    # 100.0f

    mul-float/2addr p2, v7

    invoke-static {p2}, Ljava/lang/Math;->round(F)I

    move-result p2

    const/16 v7, 0x64

    invoke-static {v7, p2}, Ljava/lang/Math;->min(II)I

    move-result p2

    invoke-static {v5, p2}, Ljava/lang/Math;->max(II)I

    move-result p2

    .line 348
    new-instance v8, Landroid/widget/TextView;

    invoke-direct {v8, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 349
    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v9, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v9

    const-string v11, "%"

    invoke-virtual {v9, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v8, v9}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 350
    const v9, -0x4c000001

    invoke-virtual {v8, v9}, Landroid/widget/TextView;->setTextColor(I)V

    .line 351
    const/high16 v9, 0x41500000    # 13.0f

    invoke-virtual {v8, v9}, Landroid/widget/TextView;->setTextSize(F)V

    .line 352
    sget-object v9, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {v8, v9}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    .line 353
    new-instance v9, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v9, v10, v10}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v4, v8, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 356
    new-instance v9, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v9, v3, v10}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p0, v4, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 359
    new-instance v4, Landroid/widget/SeekBar;

    invoke-direct {v4, v0}, Landroid/widget/SeekBar;-><init>(Landroid/content/Context;)V

    .line 360
    invoke-virtual {v4, v7}, Landroid/widget/SeekBar;->setMax(I)V

    .line 361
    invoke-virtual {v4, p2}, Landroid/widget/SeekBar;->setProgress(I)V

    .line 362
    invoke-virtual {v4, v5}, Landroid/widget/SeekBar;->setSplitTrack(Z)V

    .line 363
    invoke-static {v3}, Landroid/content/res/ColorStateList;->valueOf(I)Landroid/content/res/ColorStateList;

    move-result-object p2

    invoke-virtual {v4, p2}, Landroid/widget/SeekBar;->setProgressTintList(Landroid/content/res/ColorStateList;)V

    .line 364
    const p2, 0x33ffffff

    invoke-static {p2}, Landroid/content/res/ColorStateList;->valueOf(I)Landroid/content/res/ColorStateList;

    move-result-object p2

    invoke-virtual {v4, p2}, Landroid/widget/SeekBar;->setProgressBackgroundTintList(Landroid/content/res/ColorStateList;)V

    .line 366
    new-instance p2, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {p2}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    .line 367
    invoke-virtual {p2, v2}, Landroid/graphics/drawable/GradientDrawable;->setShape(I)V

    .line 368
    invoke-virtual {p2, v3}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    .line 369
    invoke-static {v0, v6}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result v2

    .line 370
    invoke-virtual {p2, v2, v2}, Landroid/graphics/drawable/GradientDrawable;->setSize(II)V

    .line 371
    invoke-virtual {v4, p2}, Landroid/widget/SeekBar;->setThumb(Landroid/graphics/drawable/Drawable;)V

    .line 372
    const/16 p2, 0x8

    invoke-static {v0, p2}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result v2

    invoke-virtual {v4, v2}, Landroid/widget/SeekBar;->setThumbOffset(I)V

    .line 373
    invoke-static {v0, p2}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result p2

    .line 374
    invoke-virtual {v4, p2, v5, p2, v5}, Landroid/widget/SeekBar;->setPadding(IIII)V

    .line 375
    new-instance p2, Lradiant/KaraokeMenu$VocalSliderListener;

    invoke-direct {p2, v8}, Lradiant/KaraokeMenu$VocalSliderListener;-><init>(Landroid/widget/TextView;)V

    invoke-virtual {v4, p2}, Landroid/widget/SeekBar;->setOnSeekBarChangeListener(Landroid/widget/SeekBar$OnSeekBarChangeListener;)V

    .line 377
    new-instance p2, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {p2, v3, v10}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 379
    const/4 v2, 0x4

    invoke-static {v0, v2}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result v2

    iput v2, p2, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    .line 380
    invoke-virtual {p0, v4, p2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 382
    new-instance p2, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {p2, v3, v10, v6}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    .line 385
    const/16 v2, 0x48

    invoke-static {v0, v2}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result v2

    invoke-virtual {p2, v2}, Landroid/widget/FrameLayout$LayoutParams;->setMarginStart(I)V

    .line 386
    invoke-static {v0, v6}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result v0

    invoke-virtual {p2, v0}, Landroid/widget/FrameLayout$LayoutParams;->setMarginEnd(I)V

    .line 387
    invoke-virtual {p1, p0, p2}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 388
    new-instance p0, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {p0, v3, v1}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p1, p0}, Landroid/widget/FrameLayout;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 389
    return-object p1
.end method

.method private static wrapEnd(Landroid/view/ViewGroup;Landroid/view/View;Landroid/view/View;)Landroid/view/View;
    .registers 8

    .line 403
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getContext()Landroid/content/Context;

    move-result-object p0

    .line 404
    new-instance v0, Landroid/widget/FrameLayout;

    invoke-direct {v0, p0}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    .line 405
    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v1

    .line 406
    if-eqz v1, :cond_16

    iget v2, v1, Landroid/view/ViewGroup$LayoutParams;->height:I

    if-lez v2, :cond_16

    iget v1, v1, Landroid/view/ViewGroup$LayoutParams;->height:I

    goto :goto_1c

    :cond_16
    const/16 v1, 0x38

    invoke-static {p0, v1}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result v1

    .line 407
    :goto_1c
    new-instance v2, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v3, -0x1

    invoke-direct {v2, v3, v1}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v0, p1, v2}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 408
    new-instance p1, Landroid/widget/FrameLayout$LayoutParams;

    const v2, 0x800015

    const/4 v4, -0x2

    invoke-direct {p1, v4, v4, v2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    .line 411
    const/16 v2, 0x10

    invoke-static {p0, v2}, Lradiant/KaraokeMenu;->dp(Landroid/content/Context;I)I

    move-result p0

    invoke-virtual {p1, p0}, Landroid/widget/FrameLayout$LayoutParams;->setMarginEnd(I)V

    .line 412
    const/4 p0, 0x0

    invoke-virtual {p2, p0}, Landroid/view/View;->setClickable(Z)V

    .line 413
    const/4 p0, 0x2

    invoke-virtual {p2, p0}, Landroid/view/View;->setImportantForAccessibility(I)V

    .line 414
    invoke-virtual {v0, p2, p1}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 415
    new-instance p0, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {p0, v3, v1}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v0, p0}, Landroid/widget/FrameLayout;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 416
    return-object v0
.end method


# virtual methods
.method public onApplyWindowInsets(Landroid/view/View;Landroid/view/WindowInsets;)Landroid/view/WindowInsets;
    .registers 7

    .line 437
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1e

    if-lt v0, v1, :cond_11

    .line 438
    invoke-static {}, Landroid/view/WindowInsets$Type;->navigationBars()I

    move-result v0

    invoke-virtual {p2, v0}, Landroid/view/WindowInsets;->getInsets(I)Landroid/graphics/Insets;

    move-result-object v0

    iget v0, v0, Landroid/graphics/Insets;->bottom:I

    goto :goto_15

    .line 439
    :cond_11
    invoke-virtual {p2}, Landroid/view/WindowInsets;->getSystemWindowInsetBottom()I

    move-result v0

    .line 440
    :goto_15
    invoke-virtual {p1}, Landroid/view/View;->getPaddingLeft()I

    move-result v1

    invoke-virtual {p1}, Landroid/view/View;->getPaddingTop()I

    move-result v2

    invoke-virtual {p1}, Landroid/view/View;->getPaddingRight()I

    move-result v3

    invoke-virtual {p1, v1, v2, v3, v0}, Landroid/view/View;->setPadding(IIII)V

    .line 441
    return-object p2
.end method

.method public onClick(Landroid/view/View;)V
    .registers 4

    .line 421
    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p1

    .line 422
    iget v0, p0, Lradiant/KaraokeMenu;->action:I

    packed-switch v0, :pswitch_data_20

    .line 430
    return-void

    .line 427
    :pswitch_a
    iget v0, p0, Lradiant/KaraokeMenu;->arg:I

    const/4 v1, 0x1

    if-ne v0, v1, :cond_12

    const-string v0, "instrumental"

    goto :goto_14

    :cond_12
    const-string v0, "karaoke"

    :goto_14
    invoke-static {p1, v0}, Lradiant/KaraokeBridge;->setMode(Landroid/content/Context;Ljava/lang/String;)V

    .line 428
    goto :goto_1c

    .line 424
    :pswitch_18
    invoke-static {p1}, Lradiant/KaraokeBridge;->toggle(Landroid/content/Context;)V

    .line 425
    nop

    .line 432
    :goto_1c
    invoke-static {}, Lradiant/KaraokeMenu;->refresh()V

    .line 433
    return-void

    :pswitch_data_20
    .packed-switch 0x1
        :pswitch_18
        :pswitch_a
    .end packed-switch
.end method

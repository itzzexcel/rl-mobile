.class public final Lradiant/KaraokeButton;
.super Ljava/lang/Object;
.source "KaraokeButton.java"

# interfaces
.implements Lyl0/a;
.implements Lyl0/p;
.implements Ljava/lang/Runnable;


# static fields
.field private static final CLICK_FN:Lradiant/KaraokeButton;

.field private static final ENABLED_STATE:Landroidx/compose/runtime/MutableState;

.field private static final ICON_OFF_FN:Lradiant/KaraokeButton;

.field private static final ICON_ON_FN:Lradiant/KaraokeButton;

.field private static final KIND_CLICK:I = 0x0

.field private static final KIND_ICON_OFF:I = 0x2

.field private static final KIND_ICON_ON:I = 0x3

.field private static final KIND_LONG:I = 0x1

.field private static final KIND_SYNC:I = 0x4

.field private static final LONG_FN:Lradiant/KaraokeButton;

.field private static final MAIN:Landroid/os/Handler;

.field private static final SYNC_FN:Lradiant/KaraokeButton;

.field private static appContext:Landroid/content/Context;

.field private static cachedIconId:I

.field private static hostView:Landroid/view/View;

.field private static volatile pendingEnabled:Z


# instance fields
.field private final kind:I


# direct methods
.method static constructor <clinit>()V
    .registers 3

    .line 37
    new-instance v0, Lradiant/KaraokeButton;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Lradiant/KaraokeButton;-><init>(I)V

    sput-object v0, Lradiant/KaraokeButton;->CLICK_FN:Lradiant/KaraokeButton;

    .line 38
    new-instance v0, Lradiant/KaraokeButton;

    const/4 v1, 0x1

    invoke-direct {v0, v1}, Lradiant/KaraokeButton;-><init>(I)V

    sput-object v0, Lradiant/KaraokeButton;->LONG_FN:Lradiant/KaraokeButton;

    .line 39
    new-instance v0, Lradiant/KaraokeButton;

    const/4 v1, 0x2

    invoke-direct {v0, v1}, Lradiant/KaraokeButton;-><init>(I)V

    sput-object v0, Lradiant/KaraokeButton;->ICON_OFF_FN:Lradiant/KaraokeButton;

    .line 40
    new-instance v0, Lradiant/KaraokeButton;

    const/4 v2, 0x3

    invoke-direct {v0, v2}, Lradiant/KaraokeButton;-><init>(I)V

    sput-object v0, Lradiant/KaraokeButton;->ICON_ON_FN:Lradiant/KaraokeButton;

    .line 41
    new-instance v0, Lradiant/KaraokeButton;

    const/4 v2, 0x4

    invoke-direct {v0, v2}, Lradiant/KaraokeButton;-><init>(I)V

    sput-object v0, Lradiant/KaraokeButton;->SYNC_FN:Lradiant/KaraokeButton;

    .line 43
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v2

    invoke-direct {v0, v2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v0, Lradiant/KaraokeButton;->MAIN:Landroid/os/Handler;

    .line 44
    sget-object v0, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    .line 45
    const/4 v2, 0x0

    invoke-static {v0, v2, v1, v2}, Landroidx/compose/runtime/SnapshotStateKt;->mutableStateOf$default(Ljava/lang/Object;Landroidx/compose/runtime/SnapshotMutationPolicy;ILjava/lang/Object;)Landroidx/compose/runtime/MutableState;

    move-result-object v0

    sput-object v0, Lradiant/KaraokeButton;->ENABLED_STATE:Landroidx/compose/runtime/MutableState;

    .line 44
    return-void
.end method

.method private constructor <init>(I)V
    .registers 2

    .line 54
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 55
    iput p1, p0, Lradiant/KaraokeButton;->kind:I

    .line 56
    return-void
.end method

.method public static a(Landroidx/compose/runtime/Composer;)V
    .registers 14

    .line 69
    const v0, 0x524b4152

    invoke-interface {p0, v0}, Landroidx/compose/runtime/Composer;->startReplaceGroup(I)V

    .line 72
    :try_start_6
    invoke-static {}, Landroidx/compose/ui/platform/AndroidCompositionLocals_androidKt;->getLocalView()Landroidx/compose/runtime/ProvidableCompositionLocal;

    move-result-object v0

    invoke-interface {p0, v0}, Landroidx/compose/runtime/Composer;->consume(Landroidx/compose/runtime/CompositionLocal;)Ljava/lang/Object;

    move-result-object v0

    .line 73
    instance-of v1, v0, Landroid/view/View;

    if-eqz v1, :cond_27

    .line 74
    move-object v1, v0

    check-cast v1, Landroid/view/View;

    sput-object v1, Lradiant/KaraokeButton;->hostView:Landroid/view/View;

    .line 75
    check-cast v0, Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 76
    if-eqz v0, :cond_27

    invoke-virtual {v0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    sput-object v0, Lradiant/KaraokeButton;->appContext:Landroid/content/Context;
    :try_end_25
    .catchall {:try_start_6 .. :try_end_25} :catchall_26

    goto :goto_27

    .line 78
    :catchall_26
    move-exception v0

    :cond_27
    :goto_27
    nop

    .line 80
    :try_start_28
    invoke-static {}, Lradiant/KaraokeButton;->resolveMicIconId()I

    move-result v0
    :try_end_2c
    .catchall {:try_start_28 .. :try_end_2c} :catchall_7e

    .line 81
    if-nez v0, :cond_32

    .line 114
    invoke-interface {p0}, Landroidx/compose/runtime/Composer;->endReplaceGroup()V

    .line 82
    return-void

    .line 85
    :cond_32
    :try_start_32
    sget-object v0, Lradiant/KaraokeButton;->ENABLED_STATE:Landroidx/compose/runtime/MutableState;

    invoke-interface {v0}, Landroidx/compose/runtime/MutableState;->getValue()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Boolean;

    .line 86
    if-eqz v0, :cond_44

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    if-eqz v0, :cond_44

    const/4 v0, 0x1

    goto :goto_45

    :cond_44
    const/4 v0, 0x0

    .line 88
    :goto_45
    sget-object v1, Lcom/squareup/ui/market/core/theme/k;->e:Lcom/squareup/ui/market/core/theme/k$a;

    .line 89
    const/4 v2, 0x6

    invoke-static {v1, p0, v2}, Lcom/squareup/ui/market/core/theme/d0;->t(Lcom/squareup/ui/market/core/theme/k$a;Landroidx/compose/runtime/Composer;I)Lcom/squareup/ui/market/core/theme/MarketStylesheet;

    move-result-object v3

    sget-object v4, Lcom/squareup/ui/market/core/components/properties/IconButton$Size;->MEDIUM:Lcom/squareup/ui/market/core/components/properties/IconButton$Size;

    sget-object v5, Lcom/squareup/ui/market/core/components/properties/IconButton$Rank;->SECONDARY:Lcom/squareup/ui/market/core/components/properties/IconButton$Rank;

    .line 88
    const/4 v6, 0x0

    const/4 v7, 0x4

    const/4 v8, 0x0

    invoke-static/range {v3 .. v8}, Lcom/squareup/ui/market/components/MarketIconButtonKt;->P(Lcom/squareup/ui/market/core/theme/MarketStylesheet;Lcom/squareup/ui/market/core/components/properties/IconButton$Size;Lcom/squareup/ui/market/core/components/properties/IconButton$Rank;Lcom/squareup/ui/market/core/components/properties/IconButton$Variant;ILjava/lang/Object;)Lw10/u1;

    move-result-object v8

    .line 96
    sget-object v1, Landroidx/compose/ui/Modifier;->Companion:Landroidx/compose/ui/Modifier$Companion;

    invoke-static {v1}, Lcom/tidal/android/feature/playerscreen/ui/composables/anim/BouncePressKt;->a(Landroidx/compose/ui/Modifier;)Landroidx/compose/ui/Modifier;

    move-result-object v2

    .line 98
    move v1, v0

    sget-object v0, Lradiant/KaraokeButton;->CLICK_FN:Lradiant/KaraokeButton;

    move v3, v1

    const-string v1, "Karaoke"

    sget-object v6, Lradiant/KaraokeButton;->LONG_FN:Lradiant/KaraokeButton;

    const-string v7, "Karaoke options"

    .line 108
    if-eqz v3, :cond_6c

    sget-object v3, Lradiant/KaraokeButton;->ICON_ON_FN:Lradiant/KaraokeButton;

    goto :goto_6e

    :cond_6c
    sget-object v3, Lradiant/KaraokeButton;->ICON_OFF_FN:Lradiant/KaraokeButton;

    :goto_6e
    move-object v9, v3

    .line 98
    const/4 v3, 0x0

    const/4 v4, 0x1

    const/4 v5, 0x0

    const/4 v11, 0x6

    const/16 v12, 0x28

    move-object v10, p0

    invoke-static/range {v0 .. v12}, Lcom/squareup/ui/market/components/MarketIconButtonKt;->c(Lyl0/a;Ljava/lang/String;Landroidx/compose/ui/Modifier;Landroidx/compose/foundation/interaction/MutableInteractionSource;ZLcom/squareup/ui/market/components/n;Lyl0/a;Ljava/lang/String;Lw10/u1;Lyl0/p;Landroidx/compose/runtime/Composer;II)V
    :try_end_79
    .catchall {:try_start_32 .. :try_end_79} :catchall_7e

    .line 114
    invoke-interface {p0}, Landroidx/compose/runtime/Composer;->endReplaceGroup()V

    .line 115
    nop

    .line 116
    return-void

    .line 114
    :catchall_7e
    move-exception v0

    invoke-interface {p0}, Landroidx/compose/runtime/Composer;->endReplaceGroup()V

    .line 115
    throw v0
.end method

.method private static resolveMicIconId()I
    .registers 5

    .line 119
    sget v0, Lradiant/KaraokeButton;->cachedIconId:I

    if-eqz v0, :cond_7

    sget v0, Lradiant/KaraokeButton;->cachedIconId:I

    return v0

    .line 120
    :cond_7
    sget-object v0, Lradiant/KaraokeButton;->appContext:Landroid/content/Context;

    .line 121
    const/4 v1, 0x0

    if-nez v0, :cond_26

    .line 123
    :try_start_c
    const-string v2, "android.app.ActivityThread"

    invoke-static {v2}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v2

    const-string v3, "currentApplication"

    new-array v4, v1, [Ljava/lang/Class;

    .line 124
    invoke-virtual {v2, v3, v4}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v2

    new-array v3, v1, [Ljava/lang/Object;

    const/4 v4, 0x0

    invoke-virtual {v2, v4, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/content/Context;
    :try_end_23
    .catchall {:try_start_c .. :try_end_23} :catchall_25

    .line 125
    move-object v0, v2

    goto :goto_26

    :catchall_25
    move-exception v2

    .line 127
    :cond_26
    :goto_26
    if-nez v0, :cond_29

    return v1

    .line 128
    :cond_29
    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    .line 131
    :try_start_2d
    sget v2, Lcom/aspiro/wamp/R$drawable;->ic_music_note:I

    invoke-virtual {v1, v2}, Landroid/content/res/Resources;->getResourcePackageName(I)Ljava/lang/String;

    move-result-object v0
    :try_end_33
    .catchall {:try_start_2d .. :try_end_33} :catchall_34

    .line 134
    goto :goto_39

    .line 132
    :catchall_34
    move-exception v2

    .line 133
    invoke-virtual {v0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v0

    .line 135
    :goto_39
    const-string v2, "ic_objects_mic_medium"

    const-string v3, "drawable"

    invoke-virtual {v1, v2, v3, v0}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v2

    .line 136
    if-nez v2, :cond_49

    const-string v2, "ic_objects_mic_large"

    invoke-virtual {v1, v2, v3, v0}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v2

    .line 137
    :cond_49
    if-nez v2, :cond_4d

    sget v2, Lcom/aspiro/wamp/R$drawable;->ic_music_note:I

    .line 138
    :cond_4d
    sput v2, Lradiant/KaraokeButton;->cachedIconId:I

    .line 139
    return v2
.end method

.method public static syncState(Z)V
    .registers 3

    .line 59
    sput-boolean p0, Lradiant/KaraokeButton;->pendingEnabled:Z

    .line 60
    invoke-static {}, Landroid/os/Looper;->myLooper()Landroid/os/Looper;

    move-result-object v0

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    if-ne v0, v1, :cond_16

    .line 61
    sget-object v0, Lradiant/KaraokeButton;->ENABLED_STATE:Landroidx/compose/runtime/MutableState;

    invoke-static {p0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p0

    invoke-interface {v0, p0}, Landroidx/compose/runtime/MutableState;->setValue(Ljava/lang/Object;)V

    goto :goto_1d

    .line 63
    :cond_16
    sget-object p0, Lradiant/KaraokeButton;->MAIN:Landroid/os/Handler;

    sget-object v0, Lradiant/KaraokeButton;->SYNC_FN:Lradiant/KaraokeButton;

    invoke-virtual {p0, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 65
    :goto_1d
    return-void
.end method


# virtual methods
.method public invoke()Ljava/lang/Object;
    .registers 3

    .line 144
    iget v0, p0, Lradiant/KaraokeButton;->kind:I

    const/4 v1, 0x1

    if-ne v0, v1, :cond_14

    .line 145
    sget-object v0, Lradiant/KaraokeButton;->hostView:Landroid/view/View;

    .line 146
    if-eqz v0, :cond_13

    .line 148
    const/4 v1, 0x0

    :try_start_a
    invoke-virtual {v0, v1}, Landroid/view/View;->performHapticFeedback(I)Z
    :try_end_d
    .catchall {:try_start_a .. :try_end_d} :catchall_e

    .line 149
    :goto_d
    goto :goto_10

    :catchall_e
    move-exception v1

    goto :goto_d

    .line 150
    :goto_10
    invoke-static {v0}, Lradiant/KaraokeMenu;->open(Landroid/view/View;)V

    .line 152
    :cond_13
    goto :goto_2a

    .line 153
    :cond_14
    sget-object v0, Lradiant/KaraokeButton;->appContext:Landroid/content/Context;

    if-eqz v0, :cond_1b

    sget-object v0, Lradiant/KaraokeButton;->appContext:Landroid/content/Context;

    goto :goto_27

    :cond_1b
    sget-object v0, Lradiant/KaraokeButton;->hostView:Landroid/view/View;

    if-eqz v0, :cond_26

    sget-object v0, Lradiant/KaraokeButton;->hostView:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    goto :goto_27

    :cond_26
    const/4 v0, 0x0

    .line 154
    :goto_27
    invoke-static {v0}, Lradiant/KaraokeBridge;->toggle(Landroid/content/Context;)V

    .line 156
    :goto_2a
    sget-object v0, Lkotlin/u;->a:Lkotlin/u;

    return-object v0
.end method

.method public invoke(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    .registers 5

    .line 161
    check-cast p1, Landroidx/compose/runtime/Composer;

    .line 162
    iget p2, p0, Lradiant/KaraokeButton;->kind:I

    const/4 v0, 0x3

    if-ne p2, v0, :cond_b

    const p2, 0x524b4901

    goto :goto_e

    :cond_b
    const p2, 0x524b4900

    .line 163
    :goto_e
    invoke-interface {p1, p2}, Landroidx/compose/runtime/Composer;->startReplaceGroup(I)V

    .line 165
    :try_start_11
    sget p2, Lradiant/KaraokeButton;->cachedIconId:I

    const/4 v1, 0x0

    invoke-static {p2, p1, v1}, Landroidx/compose/ui/res/PainterResources_androidKt;->painterResource(ILandroidx/compose/runtime/Composer;I)Landroidx/compose/ui/graphics/painter/Painter;

    move-result-object p2

    .line 166
    iget v1, p0, Lradiant/KaraokeButton;->kind:I

    if-ne v1, v0, :cond_20

    invoke-static {p2}, Lradiant/KaraokeMicPainter;->cyan(Landroidx/compose/ui/graphics/painter/Painter;)Landroidx/compose/ui/graphics/painter/Painter;

    move-result-object p2
    :try_end_20
    .catchall {:try_start_11 .. :try_end_20} :catchall_24

    .line 168
    :cond_20
    invoke-interface {p1}, Landroidx/compose/runtime/Composer;->endReplaceGroup()V

    .line 166
    return-object p2

    .line 168
    :catchall_24
    move-exception p2

    invoke-interface {p1}, Landroidx/compose/runtime/Composer;->endReplaceGroup()V

    .line 169
    throw p2
.end method

.method public run()V
    .registers 3

    .line 174
    sget-object v0, Lradiant/KaraokeButton;->ENABLED_STATE:Landroidx/compose/runtime/MutableState;

    sget-boolean v1, Lradiant/KaraokeButton;->pendingEnabled:Z

    invoke-static {v1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v1

    invoke-interface {v0, v1}, Landroidx/compose/runtime/MutableState;->setValue(Ljava/lang/Object;)V

    .line 175
    return-void
.end method

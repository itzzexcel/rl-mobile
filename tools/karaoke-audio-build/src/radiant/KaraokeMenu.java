package radiant;

import android.app.Activity;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.res.ColorStateList;
import android.content.res.Resources;
import android.graphics.Canvas;
import android.graphics.ColorFilter;
import android.graphics.Paint;
import android.graphics.PixelFormat;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.os.Build;
import android.os.SystemClock;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowInsets;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.SeekBar;
import android.widget.TextView;

import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.google.android.material.bottomsheet.BottomSheetDialog;

/**
 * Self-contained native TIDAL BottomSheet quick menu matching RLMenu & RLSwitch
 * design.
 */
public final class KaraokeMenu implements View.OnClickListener, View.OnApplyWindowInsetsListener {
    private static final String TAG = "RLKaraokeMenu";

    private static final int ACT_NOOP = 0;
    private static final int ACT_TOGGLE_ENABLED = 1;
    private static final int ACT_SET_MODE = 2;

    private static final String[] MODE_LABELS = { "KARA_2", "Inst HQ" };

    private static final KaraokeMenu INSETS = new KaraokeMenu(ACT_NOOP, 0);

    private static BottomSheetDialog dialog;
    private static LinearLayout list;
    private static long lastOpenMs;

    private final int action;
    private final int arg;

    private KaraokeMenu(int action, int arg) {
        this.action = action;
        this.arg = arg;
    }

    public static void open(View hostView) {
        long now = SystemClock.uptimeMillis();
        if (now - lastOpenMs < 500L)
            return;
        lastOpenMs = now;
        if (dialog != null && dialog.isShowing())
            return;

        Activity a = findActivity(hostView);
        if (a == null || a.isFinishing())
            return;
        try {
            show(a);
        } catch (Throwable t) {
            Log.e(TAG, "Failed opening KaraokeMenu", t);
        }
    }

    private static Activity findActivity(View v) {
        Context c = v == null ? null : v.getContext();
        while (c instanceof ContextWrapper) {
            if (c instanceof Activity)
                return (Activity) c;
            c = ((ContextWrapper) c).getBaseContext();
        }
        return null;
    }

    private static void show(Activity a) {
        BottomSheetDialog d = new BottomSheetDialog(a, res(a, "BottomSheetDialogTheme", "style"));
        Context c = d.getContext();
        ViewGroup root = (ViewGroup) LayoutInflater.from(c)
                .inflate(res(c, "bottom_sheet_context_menu_dialog", "layout"), null);
        int headerId = res(c, "headerContainer", "id");
        View headerView = root.findViewById(headerId);
        View rv = root.findViewById(res(c, "recyclerView", "id"));
        Drawable sheetBg = rv == null ? null : rv.getBackground();

        if (headerView instanceof FrameLayout) {
            FrameLayout header = (FrameLayout) headerView;
            boolean addedTrackHeader = false;
            try {
                Class<?> rlLyricsCls = Class.forName("radiant.RLLyrics");
                Object trackObj = rlLyricsCls.getField("track").get(null);
                if (trackObj != null) {
                    Class<?> trackCls = Class.forName("com.aspiro.wamp.model.Track");
                    Class<?> hdrCls = Class.forName(
                            "com.aspiro.wamp.contextmenu.presentation.header.track.BottomSheetTrackHeader");
                    View hdr = (View) hdrCls.getConstructor(Context.class, trackCls)
                            .newInstance(c, trackObj);
                    header.addView(hdr);
                    addedTrackHeader = true;
                }
            } catch (Throwable t) {
                Log.w(TAG, "Using fallback Karaoke header", t);
            }
            if (!addedTrackHeader) {
                int bgColor = (sheetBg instanceof ColorDrawable)
                        ? ((ColorDrawable) sheetBg).getColor()
                        : 0xFF141414;
                header.addView(buildFallbackHeader(c, bgColor));
            }
        }

        ScrollView scroll = new ScrollView(c);
        scroll.setNestedScrollingEnabled(true);
        scroll.setClipToPadding(false);
        if (sheetBg != null && sheetBg.getConstantState() != null) {
            scroll.setBackground(sheetBg.getConstantState().newDrawable());
        } else {
            scroll.setBackgroundColor(0xFF141414);
        }
        if (rv != null)
            rv.setVisibility(View.GONE);

        LinearLayout rows = new LinearLayout(c);
        rows.setOrientation(LinearLayout.VERTICAL);
        scroll.addView(rows, new FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        lp.addRule(RelativeLayout.BELOW, headerId);
        root.addView(scroll, lp);
        scroll.setOnApplyWindowInsetsListener(INSETS);

        d.setContentView(root);
        if (root.getParent() instanceof View) {
            ((View) root.getParent()).setBackgroundColor(0x00000000);
        }
        try {
            BottomSheetBehavior b = d.getBehavior();
            b.setSkipCollapsed(true);
            b.setState(3);
        } catch (Throwable ignored) {
        }

        dialog = d;
        list = rows;
        refresh();
        d.show();
        scroll.requestApplyInsets();
    }

    private static View buildFallbackHeader(Context c, int bgColor) {
        LinearLayout box = new LinearLayout(c);
        box.setOrientation(LinearLayout.VERTICAL);
        GradientDrawable bg = new GradientDrawable();
        bg.setColor(bgColor);
        float r = dp(c, 16);
        bg.setCornerRadii(new float[] { r, r, r, r, 0f, 0f, 0f, 0f });
        box.setBackground(bg);

        LinearLayout textCol = new LinearLayout(c);
        textCol.setOrientation(LinearLayout.VERTICAL);
        int padH = dp(c, 20);
        textCol.setPadding(padH, dp(c, 16), padH, dp(c, 14));

        TextView title = new TextView(c);
        title.setText("Karaoke");
        title.setTextColor(0xFFFFFFFF);
        title.setTextSize(17f);
        title.setTypeface(Typeface.DEFAULT_BOLD);
        textCol.addView(title);

        TextView sub = new TextView(c);
        sub.setText("Accelerated by Qualcomm® Hexagon™ NPU");
        sub.setTextColor(0x80FFFFFF);
        sub.setTextSize(12f);
        LinearLayout.LayoutParams subLp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        subLp.topMargin = dp(c, 2);
        textCol.addView(sub, subLp);

        box.addView(textCol);

        View div = new View(c);
        div.setBackgroundColor(0x14FFFFFF);
        box.addView(div, new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, Math.max(1, dp(c, 1))));
        return box;
    }

    private static void refresh() {
        LinearLayout l = list;
        if (l == null)
            return;
        l.removeAllViews();
        Context c = l.getContext();

        boolean on = KaraokeBridge.isEnabled();
        int modeIdx = "instrumental".equals(KaraokeBridge.getMode()) ? 1 : 0;
        float vg = KaraokeBridge.getVocalGain();

        String statusText;
        if (!on) {
            statusText = "Idle · 0 MB";
        } else {
            double ms = KaraokeBridge.getLastMs();
            String msStr = ms > 0.0 ? (" · " + Math.round(ms) + " ms") : "";
            statusText = KaraokeBridge.getLastProvider() + msStr;
        }

        l.addView(toggleRow(l, "ic_objects_mic_large", "Karaoke", on, ACT_TOGGLE_ENABLED));
        l.addView(segmentedRow(l, "ic_media_music_note_large", MODE_LABELS, modeIdx, ACT_SET_MODE));
        l.addView(vocalSliderRow(l, "ic_objects_mic_medium", vg));

        View div = new View(c);
        div.setBackgroundColor(0x14FFFFFF);
        LinearLayout.LayoutParams dlp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, Math.max(1, dp(c, 1)));
        dlp.setMargins(dp(c, 16), dp(c, 4), dp(c, 16), dp(c, 4));
        l.addView(div, dlp);

        l.addView(statusRow(l, "ic_music_note", "Hexagon NPU", statusText));
    }

    private static View row(ViewGroup parent, String iconName, CharSequence title, int textColor, int iconColor,
            int action) {
        Context c = parent.getContext();
        View v = LayoutInflater.from(c).inflate(res(c, "context_menu_item", "layout"), parent, false);
        ImageView icon = (ImageView) v.findViewById(res(c, "icon", "id"));
        TextView tv = (TextView) v.findViewById(res(c, "title", "id"));
        if (icon != null) {
            Drawable d = drawable(c, iconName);
            if (d != null) {
                d = d.mutate();
                d.setTint(iconColor);
                icon.setImageDrawable(d);
                int px = dp(c, 24);
                ViewGroup.LayoutParams ip = icon.getLayoutParams();
                if (ip != null) {
                    ip.width = px;
                    ip.height = px;
                    icon.setLayoutParams(ip);
                }
            }
        }
        if (tv != null) {
            tv.setText(title);
            tv.setTextColor(textColor);
        }
        v.setEnabled(action != ACT_NOOP);
        v.setClickable(action != ACT_NOOP);
        v.setOnClickListener(action != ACT_NOOP ? new KaraokeMenu(action, 0) : null);
        return v;
    }

    private static View toggleRow(ViewGroup parent, String iconName, String title, boolean on, int action) {
        Context c = parent.getContext();
        View base = row(parent, iconName, title, 0xFFFFFFFF, 0xFFFFFFFF, action);
        ImageView sw = new ImageView(c);
        sw.setImageDrawable(new ToggleDrawable(on, c.getResources().getDisplayMetrics().density));
        return wrapEnd(parent, base, sw);
    }

    // Matching RLMenu.syncRow segmented control
    private static View segmentedRow(ViewGroup parent, String iconName, String[] labels, int selectedIdx, int action) {
        Context c = parent.getContext();
        View base = row(parent, iconName, "", 0xFFFFFFFF, 0xFFFFFFFF, ACT_NOOP);
        FrameLayout f = new FrameLayout(c);
        ViewGroup.LayoutParams rp = base.getLayoutParams();
        int h = rp != null && rp.height > 0 ? rp.height : dp(c, 56);
        f.addView(base, new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, h));

        LinearLayout seg = new LinearLayout(c);
        seg.setOrientation(LinearLayout.HORIZONTAL);
        GradientDrawable track = new GradientDrawable();
        track.setCornerRadius(dp(c, 10));
        track.setColor(0x1FFFFFFF);
        seg.setBackground(track);
        int pad = dp(c, 3);
        seg.setPadding(pad, pad, pad, pad);

        for (int i = 0; i < labels.length; i++) {
            TextView b = new TextView(c);
            b.setText(labels[i]);
            b.setGravity(Gravity.CENTER);
            b.setTextSize(13f);
            b.setTypeface(Typeface.DEFAULT_BOLD);
            if (i == selectedIdx) {
                GradientDrawable sel = new GradientDrawable();
                sel.setCornerRadius(dp(c, 8));
                sel.setColor(0xFFFFFFFF);
                b.setBackground(sel);
                b.setTextColor(0xFF000000);
            } else {
                b.setTextColor(0xB3FFFFFF);
            }
            b.setOnClickListener(new KaraokeMenu(action, i));
            seg.addView(b, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.MATCH_PARENT, 1f));
        }

        FrameLayout.LayoutParams sp = new FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, dp(c, 36), Gravity.CENTER_VERTICAL);
        sp.setMarginStart(dp(c, 72));
        sp.setMarginEnd(dp(c, 16));
        f.addView(seg, sp);
        f.setLayoutParams(new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, h));
        return f;
    }

    private static View vocalSliderRow(ViewGroup parent, String iconName, float vocalGain) {
        Context c = parent.getContext();
        int h = dp(c, 68);
        View base = row(parent, iconName, "", 0xFFFFFFFF, 0xFFFFFFFF, ACT_NOOP);
        FrameLayout f = new FrameLayout(c);
        f.addView(base, new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, h));

        LinearLayout col = new LinearLayout(c);
        col.setOrientation(LinearLayout.VERTICAL);

        LinearLayout headerRow = new LinearLayout(c);
        headerRow.setOrientation(LinearLayout.HORIZONTAL);
        headerRow.setGravity(Gravity.CENTER_VERTICAL);

        TextView labelTv = new TextView(c);
        labelTv.setText("Vocals");
        labelTv.setTextColor(0xFFFFFFFF);
        labelTv.setTextSize(14f);
        headerRow.addView(labelTv, new LinearLayout.LayoutParams(
                0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f));

        int pct = Math.max(0, Math.min(100, Math.round(vocalGain * 100f)));
        TextView valTv = new TextView(c);
        valTv.setText(pct + "%");
        valTv.setTextColor(0xB3FFFFFF);
        valTv.setTextSize(13f);
        valTv.setTypeface(Typeface.DEFAULT_BOLD);
        headerRow.addView(valTv, new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        col.addView(headerRow, new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        SeekBar sb = new SeekBar(c);
        sb.setMax(100);
        sb.setProgress(pct);
        sb.setSplitTrack(false);
        sb.setProgressTintList(ColorStateList.valueOf(0xFFFFFFFF));
        sb.setProgressBackgroundTintList(ColorStateList.valueOf(0x33FFFFFF));

        GradientDrawable thumb = new GradientDrawable();
        thumb.setShape(GradientDrawable.OVAL);
        thumb.setColor(0xFFFFFFFF);
        int thumbPx = dp(c, 16);
        thumb.setSize(thumbPx, thumbPx);
        sb.setThumb(thumb);
        sb.setThumbOffset(dp(c, 8));
        int hPad = dp(c, 8);
        sb.setPadding(hPad, 0, hPad, 0);
        sb.setOnSeekBarChangeListener(new VocalSliderListener(valTv));

        LinearLayout.LayoutParams sbp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        sbp.topMargin = dp(c, 4);
        col.addView(sb, sbp);

        FrameLayout.LayoutParams sp = new FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT,
                Gravity.CENTER_VERTICAL);
        sp.setMarginStart(dp(c, 72));
        sp.setMarginEnd(dp(c, 16));
        f.addView(col, sp);
        f.setLayoutParams(new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, h));
        return f;
    }

    private static View statusRow(ViewGroup parent, String iconName, String title, String val) {
        Context c = parent.getContext();
        View base = row(parent, iconName, title, 0xB3FFFFFF, 0x99FFFFFF, ACT_NOOP);
        TextView tv = new TextView(c);
        tv.setText(val);
        tv.setTextColor(0x99FFFFFF);
        tv.setTextSize(13f);
        return wrapEnd(parent, base, tv);
    }

    private static View wrapEnd(ViewGroup parent, View base, View end) {
        Context c = parent.getContext();
        FrameLayout f = new FrameLayout(c);
        ViewGroup.LayoutParams rp = base.getLayoutParams();
        int h = rp != null && rp.height > 0 ? rp.height : dp(c, 56);
        f.addView(base, new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, h));
        FrameLayout.LayoutParams ep = new FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT,
                Gravity.END | Gravity.CENTER_VERTICAL);
        ep.setMarginEnd(dp(c, 16));
        end.setClickable(false);
        end.setImportantForAccessibility(View.IMPORTANT_FOR_ACCESSIBILITY_NO);
        f.addView(end, ep);
        f.setLayoutParams(new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, h));
        return f;
    }

    @Override
    public void onClick(View v) {
        Context c = v.getContext();
        switch (action) {
            case ACT_TOGGLE_ENABLED:
                KaraokeBridge.toggle(c);
                break;
            case ACT_SET_MODE:
                KaraokeBridge.setMode(c, arg == 1 ? "instrumental" : "karaoke");
                break;
            default:
                return;
        }
        refresh();
    }

    @Override
    public WindowInsets onApplyWindowInsets(View v, WindowInsets insets) {
        int bottom = Build.VERSION.SDK_INT >= 30
                ? insets.getInsets(WindowInsets.Type.navigationBars()).bottom
                : insets.getSystemWindowInsetBottom();
        v.setPadding(v.getPaddingLeft(), v.getPaddingTop(), v.getPaddingRight(), bottom);
        return insets;
    }

    private static int res(Context c, String name, String type) {
        Resources r = c.getResources();
        String pkg;
        try {
            pkg = r.getResourcePackageName(com.aspiro.wamp.R.drawable.ic_music_note);
        } catch (Throwable t) {
            pkg = c.getPackageName();
        }
        return r.getIdentifier(name, type, pkg);
    }

    private static Drawable drawable(Context c, String name) {
        int id = res(c, name, "drawable");
        if (id == 0)
            id = res(c, "ic_music_note", "drawable");
        try {
            return id == 0 ? null : c.getDrawable(id);
        } catch (Throwable t) {
            return null;
        }
    }

    private static int dp(Context c, int v) {
        return Math.round(v * c.getResources().getDisplayMetrics().density);
    }

    /**
     * Pixel-exact match of radiant.RLSwitch so KaraokeMenu has zero external
     * dependencies.
     */
    private static final class ToggleDrawable extends Drawable {
        private final boolean on;
        private final int w;
        private final int h;
        private final Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
        private final RectF rect = new RectF();

        ToggleDrawable(boolean on, float density) {
            this.on = on;
            this.w = Math.round(40f * density);
            this.h = Math.round(24f * density);
        }

        @Override
        public void draw(Canvas canvas) {
            Rect b = getBounds();
            float bw = b.width();
            float bh = b.height();
            float r = bh / 2f;
            rect.set(b.left, b.top, b.left + bw, b.top + bh);
            paint.setColor(on ? 0xFFFFFFFF : 0x33FFFFFF);
            paint.setAlpha(on ? 0xFF : 0x33);
            canvas.drawRoundRect(rect, r, r, paint);
            float inset = bh * 0.15f;
            float kr = r - inset;
            float cx = on ? b.left + bw - r : b.left + r;
            paint.setColor(on ? 0xFF000000 : 0xFFFFFFFF);
            paint.setAlpha(on ? 0xFF : 0xCC);
            canvas.drawCircle(cx, b.top + r, kr, paint);
        }

        @Override
        public int getIntrinsicWidth() {
            return w;
        }

        @Override
        public int getIntrinsicHeight() {
            return h;
        }

        @Override
        public void setAlpha(int alpha) {
        }

        @Override
        public void setColorFilter(ColorFilter colorFilter) {
        }

        @Override
        public int getOpacity() {
            return PixelFormat.TRANSLUCENT;
        }
    }

    private static final class VocalSliderListener implements SeekBar.OnSeekBarChangeListener {
        private final TextView valTv;

        VocalSliderListener(TextView valTv) {
            this.valTv = valTv;
        }

        @Override
        public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
            valTv.setText(progress + "%");
            KaraokeBridge.setVocalGain(seekBar.getContext(), progress / 100f);
        }

        @Override
        public void onStartTrackingTouch(SeekBar seekBar) {
            if (seekBar.getParent() != null) {
                seekBar.getParent().requestDisallowInterceptTouchEvent(true);
            }
        }

        @Override
        public void onStopTrackingTouch(SeekBar seekBar) {
            if (seekBar.getParent() != null) {
                seekBar.getParent().requestDisallowInterceptTouchEvent(false);
            }
        }
    }
}

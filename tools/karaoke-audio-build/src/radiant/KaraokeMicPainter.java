package radiant;

import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;

import androidx.compose.ui.geometry.Size;
import androidx.compose.ui.graphics.AndroidCanvas_androidKt;
import androidx.compose.ui.graphics.ColorFilter;
import androidx.compose.ui.graphics.drawscope.DrawScope;
import androidx.compose.ui.graphics.painter.Painter;

/**
 * Wraps TIDAL's mic icon Painter with an active soft Cyan (#5EE7FF) SRC_IN layer,
 * matching RLMenu's Radiant palette when Karaoke NPU is ON.
 */
public final class KaraokeMicPainter extends Painter {
    private static Painter cachedInner;
    private static KaraokeMicPainter cachedCyan;

    private final Painter inner;
    private final Paint tintPaint = new Paint(Paint.ANTI_ALIAS_FLAG);

    private KaraokeMicPainter(Painter inner) {
        this.inner = inner;
        tintPaint.setColor(0xFF5EE7FF);
        tintPaint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));
    }

    public static Painter cyan(Painter inner) {
        if (inner == null) return null;
        KaraokeMicPainter p = cachedCyan;
        if (p == null || cachedInner != inner) {
            cachedInner = inner;
            p = new KaraokeMicPainter(inner);
            cachedCyan = p;
        }
        return p;
    }

    @Override
    public long getIntrinsicSizeNHjbRc() {
        return inner.getIntrinsicSizeNHjbRc();
    }

    @Override
    public boolean applyColorFilter(ColorFilter colorFilter) {
        return true;
    }

    @Override
    public void onDraw(DrawScope scope) {
        long size = scope.getSizeNHjbRc();
        float w = Size.getWidthImpl(size);
        float h = Size.getHeightImpl(size);
        if (w <= 0f || h <= 0f) return;
        Canvas canvas = AndroidCanvas_androidKt.getNativeCanvas(scope.getDrawContext().getCanvas());
        int save = canvas.saveLayer(0f, 0f, w, h, null);
        inner.drawxKDEd0(scope, size, 1f, null);
        canvas.drawRect(0f, 0f, w, h, tintPaint);
        canvas.restoreToCount(save);
    }
}

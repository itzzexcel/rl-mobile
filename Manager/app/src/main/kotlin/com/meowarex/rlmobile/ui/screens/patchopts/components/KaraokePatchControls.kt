package com.meowarex.rlmobile.ui.screens.patchopts.components

import android.os.Build
import android.util.Log
import android.widget.Toast
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.compose.LocalLifecycleOwner
import androidx.lifecycle.repeatOnLifecycle
import com.meowarex.rlmobile.BuildConfig
import com.meowarex.rlmobile.R
import com.meowarex.rlmobile.karaoke.KaraokeLocalServer
import com.meowarex.rlmobile.karaoke.ModelCatalog
import com.meowarex.rlmobile.ui.components.radiant.RadiantButton
import com.meowarex.rlmobile.ui.components.radiant.RadiantButtonSize
import com.meowarex.rlmobile.ui.components.radiant.RadiantButtonStyle
import com.meowarex.rlmobile.util.showToast
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.json.JSONObject
import kotlin.math.roundToInt

/**
 * Self-contained Karaoke NPU model & benchmark controls rendered inside the
 * Karaoke (Hexagon NPU) card in the Patches accordion, keeping Settings clean.
 */
@Composable
fun KaraokePatchControls(modifier: Modifier = Modifier) {
    val context = LocalContext.current
    val appContext = context.applicationContext
    val lifecycleOwner = LocalLifecycleOwner.current
    val scope = rememberCoroutineScope()

    var karaInstalled by remember { mutableStateOf(false) }
    var karaSizeMb by remember { mutableStateOf(0.0) }
    var karaDownloading by remember { mutableStateOf(false) }
    var karaProgress by remember { mutableFloatStateOf(0f) }

    var instInstalled by remember { mutableStateOf(false) }
    var instSizeMb by remember { mutableStateOf(0.0) }
    var instDownloading by remember { mutableStateOf(false) }
    var instProgress by remember { mutableFloatStateOf(0f) }

    var cacheEntries by remember { mutableIntStateOf(0) }
    var cacheMb by remember { mutableStateOf(0.0) }

    var npuRunning by remember { mutableStateOf(false) }
    var npuSummary by remember {
        mutableStateOf("Ready · SoC ${Build.SOC_MODEL.ifBlank { Build.BOARD }}")
    }

    suspend fun reloadState() {
        val kInst = withContext(Dispatchers.IO) { ModelCatalog.isModelInstalled(appContext, "karaoke") }
        val kSize = withContext(Dispatchers.IO) { ModelCatalog.getModelSizeMb(appContext, "karaoke") }
        val iInst = withContext(Dispatchers.IO) { ModelCatalog.isModelInstalled(appContext, "instrumental") }
        val iSize = withContext(Dispatchers.IO) { ModelCatalog.getModelSizeMb(appContext, "instrumental") }
        val (entries, mb) = withContext(Dispatchers.IO) { KaraokeLocalServer.getCacheStats(appContext) }
        karaInstalled = kInst
        karaSizeMb = kSize
        instInstalled = iInst
        instSizeMb = iSize
        cacheEntries = entries
        cacheMb = mb
    }

    LaunchedEffect(lifecycleOwner) {
        lifecycleOwner.repeatOnLifecycle(Lifecycle.State.RESUMED) {
            reloadState()
        }
    }

    fun toggleModelDownload(mode: String, installed: Boolean) {
        val isInst = ModelCatalog.normalizeMode(mode) == "instrumental"
        if (installed) {
            scope.launch {
                withContext(Dispatchers.IO) {
                    KaraokeLocalServer.unloadModelIfLoaded(mode)
                    ModelCatalog.deleteModel(appContext, mode)
                }
                reloadState()
                Toast.makeText(appContext, "Removed $mode model", Toast.LENGTH_SHORT).show()
            }
            return
        }
        if (if (isInst) instDownloading else karaDownloading) return
        if (isInst) {
            instDownloading = true
            instProgress = 0f
        } else {
            karaDownloading = true
            karaProgress = 0f
        }
        scope.launch {
            try {
                withContext(Dispatchers.IO) {
                    ModelCatalog.downloadModel(appContext, mode) { p ->
                        scope.launch { if (isInst) instProgress = p else karaProgress = p }
                    }
                }
                Toast.makeText(appContext, "Model ready ($mode)", Toast.LENGTH_SHORT).show()
            } catch (t: Throwable) {
                Log.w(BuildConfig.TAG, "Failed downloading $mode model", t)
                Toast.makeText(appContext, "Download failed: ${t.message}", Toast.LENGTH_SHORT).show()
            } finally {
                if (isInst) {
                    instDownloading = false
                    instProgress = 0f
                } else {
                    karaDownloading = false
                    karaProgress = 0f
                }
                reloadState()
            }
        }
    }

    Column(
        verticalArrangement = Arrangement.spacedBy(8.dp),
        modifier = modifier
            .fillMaxWidth()
            .padding(top = 4.dp),
    ) {
        KaraokeControlRow(
            title = "Karaoke Model (KARA_2)",
            subtitle = when {
                karaDownloading -> "Downloading ${(karaProgress * 100).toInt()}%..."
                karaInstalled -> "Installed · $karaSizeMb MB"
                else -> "Not installed"
            },
            buttonText = when {
                karaDownloading -> "${(karaProgress * 100).toInt()}%"
                karaInstalled -> "Delete"
                else -> "Download"
            },
            danger = karaInstalled,
            enabled = !karaDownloading,
            onClick = { toggleModelDownload("karaoke", karaInstalled) },
        )

        KaraokeControlRow(
            title = "Instrumental Model (Inst_HQ_3)",
            subtitle = when {
                instDownloading -> "Downloading ${(instProgress * 100).toInt()}%..."
                instInstalled -> "Installed · $instSizeMb MB"
                else -> "Not installed"
            },
            buttonText = when {
                instDownloading -> "${(instProgress * 100).toInt()}%"
                instInstalled -> "Delete"
                else -> "Download"
            },
            danger = instInstalled,
            enabled = !instDownloading,
            onClick = { toggleModelDownload("instrumental", instInstalled) },
        )

        KaraokeControlRow(
            title = "Hexagon NPU Benchmark",
            subtitle = npuSummary,
            buttonText = if (npuRunning) "..." else "Test NPU",
            danger = false,
            enabled = !npuRunning,
            onClick = {
                if (npuRunning) return@KaraokeControlRow
                npuRunning = true
                npuSummary = "Running QNN HTP benchmark..."
                scope.launch {
                    try {
                        val reportStr = withContext(Dispatchers.IO) {
                            KaraokeLocalServer.runLocalSelfTest(appContext)
                        }
                        val onnxArr = JSONObject(reportStr).optJSONArray("onnx")
                        val parts = ArrayList<String>()
                        if (onnxArr != null) {
                            for (i in 0 until onnxArr.length()) {
                                val o = onnxArr.getJSONObject(i)
                                if (o.optBoolean("installed", false)) {
                                    val m = if (o.optString("mode") == "instrumental") "Inst" else "Kara"
                                    val prov = o.optString("provider", "?")
                                    val ms = ((o.optDouble("chunkMs", 0.0) * 10.0).roundToInt() / 10.0)
                                    parts.add("$m: $prov ${ms}ms")
                                }
                            }
                        }
                        npuSummary = if (parts.isEmpty()) {
                            "FFT OK (install a model to test QNN NPU)"
                        } else {
                            parts.joinToString(" · ")
                        }
                    } catch (t: Throwable) {
                        npuSummary = "Test failed: ${t.message}"
                    } finally {
                        npuRunning = false
                        reloadState()
                    }
                }
            },
        )

        KaraokeControlRow(
            title = "Stem Cache (KRK1)",
            subtitle = "$cacheEntries stems · $cacheMb MB",
            buttonText = "Clear",
            danger = true,
            enabled = cacheEntries > 0,
            onClick = {
                scope.launch {
                    withContext(Dispatchers.IO) { KaraokeLocalServer.clearStemCache(appContext) }
                    reloadState()
                    appContext.showToast(R.string.action_cleared_cache)
                }
            },
        )
    }
}

@Composable
private fun KaraokeControlRow(
    title: String,
    subtitle: String,
    buttonText: String,
    danger: Boolean,
    enabled: Boolean,
    onClick: () -> Unit,
) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(12.dp),
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 2.dp),
    ) {
        Column(
            verticalArrangement = Arrangement.spacedBy(2.dp),
            modifier = Modifier.weight(1f),
        ) {
            Text(
                text = title,
                style = MaterialTheme.typography.titleSmall,
            )
            Text(
                text = subtitle,
                style = MaterialTheme.typography.bodySmall,
                modifier = Modifier.alpha(.7f),
            )
        }
        RadiantButton(
            text = buttonText,
            style = if (danger) RadiantButtonStyle.Danger else RadiantButtonStyle.Glass,
            size = RadiantButtonSize.Small,
            enabled = enabled,
            onClick = onClick,
        )
    }
}

package app.obaldevshi.notspent

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.view.View
import android.widget.RemoteViews
import org.json.JSONArray
import java.text.NumberFormat
import java.util.Locale

class SavingsWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        for (id in ids) {
            val views = RemoteViews(context.packageName, R.layout.savings_widget)
            val preferences = context.getSharedPreferences("savings_widget", Context.MODE_PRIVATE)
            val locale = preferences.getString("locale", null)?.let { Locale.forLanguageTag(it) } ?: Locale.getDefault()
            views.setTextViewText(R.id.saving_title, preferences.getString("title", context.getString(R.string.saving_widget_title)))
            views.setTextViewText(R.id.saving_empty, preferences.getString("empty", context.getString(R.string.saving_widget_empty)))
            val items = try { JSONArray(preferences.getString("items", "[]")) } catch (_: Exception) { JSONArray() }
            val rows = intArrayOf(R.id.saving_one, R.id.saving_two, R.id.saving_three)
            for (index in rows.indices) {
                val item = items.optJSONObject(index)
                views.setViewVisibility(rows[index], if (item == null) View.GONE else View.VISIBLE)
                if (item != null) {
                    val amount = NumberFormat.getNumberInstance(locale).format(item.optDouble("amount"))
                    views.setTextViewText(rows[index], "${item.optString("name")} · $amount ${item.optString("currency", "RUB")}")
                    val launch = Intent(context, MainActivity::class.java).apply {
                        putExtra("saving_impulse", item.getInt("id"))
                        flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
                    }
                    views.setOnClickPendingIntent(rows[index], PendingIntent.getActivity(context,
                        item.getInt("id"), launch, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE))
                }
            }
            views.setViewVisibility(R.id.saving_empty, if (items.length() == 0) View.VISIBLE else View.GONE)
            val open = PendingIntent.getActivity(context, 0, Intent(context, MainActivity::class.java),
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            views.setOnClickPendingIntent(R.id.saving_title, open)
            views.setOnClickPendingIntent(R.id.saving_empty, open)
            manager.updateAppWidget(id, views)
        }
    }

    companion object {
        fun refresh(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(ComponentName(context, SavingsWidgetProvider::class.java))
            SavingsWidgetProvider().onUpdate(context, manager, ids)
        }
    }
}

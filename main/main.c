#include <inttypes.h>
#include <stdbool.h>

#include "esp_chip_info.h"
#include "esp_err.h"
#include "esp_flash.h"
#include "esp_log.h"
#include "esp_system.h"
#include "esp_timer.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

static const char *TAG = "redfish-server";

void app_main(void)
{
    esp_chip_info_t chip;
    uint32_t flash_size;
    esp_chip_info(&chip);
    ESP_ERROR_CHECK(esp_flash_get_size(NULL, &flash_size));

    ESP_LOGI(TAG, "Redfish Server starter firmware");
    ESP_LOGI(TAG, "ESP-IDF %s; %d cores; chip revision %d.%d",
             esp_get_idf_version(), chip.cores, chip.revision / 100, chip.revision % 100);
    ESP_LOGI(TAG, "Flash: %" PRIu32 " MiB", flash_size / (1024 * 1024));

    while (true) {
        ESP_LOGI(TAG, "Heartbeat: uptime=%" PRId64 " s, free heap=%" PRIu32 " bytes",
                 esp_timer_get_time() / 1000000, esp_get_free_heap_size());
        vTaskDelay(pdMS_TO_TICKS(5000));
    }
}

// 1. Dichiariamo a quale nodo del Device Tree risponde questo driver
#define DT_DRV_COMPAT custom_pca9536

#include <zephyr/kernel.h>
#include <zephyr/device.h>
#include <zephyr/drivers/i2c.h>
#include <zephyr/logging/log.h>

// Inizializza il logger di Zephyr per poter fare debug
LOG_MODULE_REGISTER(pca9536, LOG_LEVEL_INF);

// 2. Struttura di configurazione (i dati presi dall'overlay)
struct pca9536_config {
    struct i2c_dt_spec i2c; // Contiene il bus I2C e l'indirizzo (0x41)
};

// 3. Funzione di utilità per scrivere un registro I2C
static int pca9536_write_reg(const struct device *dev, uint8_t reg, uint8_t val) {
    const struct pca9536_config *config = dev->config;
    uint8_t buf[2] = {reg, val};
    
    // Usa le API I2C native di Zephyr
    return i2c_write_dt(&config->i2c, buf, sizeof(buf));
}

// 4. La funzione di inizializzazione che Zephyr chiama al boot
static int pca9536_init(const struct device *dev) {
    const struct pca9536_config *config = dev->config;

    // Controlla se il bus I2C è pronto (es. i pin sono configurati bene)
    if (!i2c_is_ready_dt(&config->i2c)) {
        LOG_ERR("Bus I2C non pronto per PCA9536");
        return -ENODEV;
    }

    LOG_INF("PCA9536 inizializzato con successo sull'indirizzo 0x%02x", config->i2c.addr);

    // Esempio: Scriviamo nel registro di configurazione (0x03) per settare i pin come output (0x00)
    // pca9536_write_reg(dev, 0x03, 0x00);

    return 0;
}

// 5. La macro magica di Zephyr
// Questa macro cerca tutti i nodi nell'overlay con compatible="custom,pca9536"
// e per ognuno crea l'istanza e chiama pca9536_init al momento giusto dell'avvio.
#define PCA9536_DEFINE(inst)                                            \
    static const struct pca9536_config pca9536_config_##inst = {        \
        .i2c = I2C_DT_SPEC_INST_GET(inst),                              \
    };                                                                  \
                                                                        \
    DEVICE_DT_INST_DEFINE(inst, pca9536_init, NULL,                     \
                          NULL, &pca9536_config_##inst,                 \
                          POST_KERNEL, CONFIG_SENSOR_INIT_PRIORITY,     \
                          NULL);

// Esegue la macro per ogni istanza trovata (tu ne avrai 1)
DT_INST_FOREACH_STATUS_OKAY(PCA9536_DEFINE)

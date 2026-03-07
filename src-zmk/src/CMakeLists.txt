# CMakeLists

# Inizializza una nuova libreria logica per Zephyr
zephyr_library()

# Aggiungi i file sorgente SOLO SE il relativo flag Kconfig è =y
# Questa macro è potente: se CONFIG_CUSTOM_CIRQUE_TRACKPAD è abilitato
# nel .conf del lato destro, compilerà il file, altrimenti lo ignora.
zephyr_library_sources_ifdef(CONFIG_CUSTOM_CIRQUE_TRACKPAD cirque_trackpad.c)
zephyr_library_sources_ifdef(CONFIG_CUSTOM_CIRQUE_TRACKPAD pca9536d.c)

# Se hai una cartella 'include' dentro 'src' per i tuoi .h, dillo al compilatore:
# zephyr_include_directories(include)

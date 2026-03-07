La cartella `zephyr_module_tmp/` serve ancora?

Per la compilazione: Usare just compile-left , ecc...

```bash
west build -p -s zmk-workspace/app -d build/left -b nice_nano_v2 -- -DZMK_CONFIG="/percorso/assoluto/a/my-keyboard-zmk/config" -DSHIELD=my_split_left
```

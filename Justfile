# Justfile

default:
    @just --list

# Upgrade pip (when should be used?)
upgrade-pip:
    @echo "Upgrading pip..."
    pip install --upgrade pip

# To use when adding a dependencies in requirements.in (Only for Developers)
setup-pip-lock:
    just upgrade-pip
    @echo "Instlling pip-tools..."
    pip install pip-tools
    @echo "Creating requirments.txt..."
    pip-compile -v requirements.in

# Initalize entire environment
init:
    just upgrade-pip
    @echo "Instlling dependencies with pip..."
    pip install -r requirements.txt
    @echo "Setting up zmk environment..."
    @just -f src-zmk/Justfile -d src-zmk init

# 3D Model commands 
model *args:
    @just -f model/Justfile -d model {{args}}

# PCB commands
pcb *args:
    @just -f pcb/Justfile -d pcb {{args}}

# Src zmk framework commands
src-zmk *args:
    @just -f src-zmk/Justfile -d src-zmk {{args}}

#cleanzmk:
#    rm -rf .west/ zephyr/ zmk/ modules/ optional/

# (In futuro potrai aggiungere comandi per KiCad o OpenSCAD)
# pcb *args:
#     @just -f pcb/Justfile -d pcb {{args}}

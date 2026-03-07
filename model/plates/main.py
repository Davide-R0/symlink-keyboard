import math
from build123d import Location, Locations, Rectangle, BuildSketch, BuildPart, BuildLine, make_hull, add, Vector, Polygon, fillet, Wire, Text
from ocp_vscode import show

# ==========================================
# PARAMETRI
# ==========================================

n_rows = 4 # 4
n_cols = 6
n_thumb = 5
n_thumb_r = 3
key_w = 19.05
key_fix_hole_w = 14.0
key_col_offsets = [20, 18, 6, 0, 8, 10]
thumb_rotation_radius = 75.0
util_w = 40.0
pcb_top_h = 1.2
outer_radius = 3.0

# ==========================================
# FUNZIONI POSIZIONI
# ==========================================

# Generate the table with the keys location for the main keys matrix
def get_finger_keys_locations():
    locs = []
    for i in range(n_cols):
        for j in range(n_rows):
            x = i * key_w + key_w / 2
            y = -key_col_offsets[i] - j * key_w - key_w / 2
            locs.append(Location((x, y)))
    return locs


# Generate the table with the keys location for the thumb keys matrix
def get_thumb_keys_locations():
    # TODO: al posto di calcolare le posizioni manualmente usare la funzione apposita:
    ## Crea 3 posizioni su un arco di 45 gradi con raggio 70
    #pos_arco = PolarLocations(radius=70, count=3, angular_range=45)
    #with Locations(pos_arco):
    #    Rectangle(14, 14) # I rettangoli saranno già ruotati verso il centro!

    low_point = min(key_col_offsets[n_cols-2] + key_w*n_rows, key_col_offsets[n_cols-1] + key_w*n_rows)
    low_radius = thumb_rotation_radius - key_w/2

    y_point = -low_point - (thumb_rotation_radius + key_w/2 + 2.5)
    x_point = (n_cols - 1) * key_w

    a = math.sqrt((key_w/2)**2 + low_radius**2)
    half_theta = math.degrees(math.acos(low_radius/a))
    rot_step = 2 * half_theta

    locs = []

    # riht side keys
    for i in range(n_thumb_r):
        t = half_theta + i * rot_step
        x = x_point + thumb_rotation_radius * math.cos(math.radians(t - 90))
        y = y_point - thumb_rotation_radius * math.sin(math.radians(t - 90))
        locs.append(Location((x, y), (0, 0, 90 - t)))
    # Left side keys
    for i in range(n_thumb - n_thumb_r):
        t = half_theta + i * rot_step
        x = x_point + thumb_rotation_radius * math.cos(math.radians(t + 90))
        y = y_point + thumb_rotation_radius * math.sin(math.radians(t + 90))
        locs.append(Location((x, y), (0, 0, t + 90)))

    locs.sort(key=lambda l: l.position.X)
    return locs


# ==========================================
# MODELLAZIONE
# ==========================================

finger_locs = get_finger_keys_locations()
thumb_locs = get_thumb_keys_locations()
max_offset = max(key_col_offsets)

with BuildSketch() as keys_matrix:
    #finger matrix
    with Locations(finger_locs):
        Rectangle(key_w, key_w)
    #Rettangoli di connessione per evitare "isole"
    # TODO: rivedere perchè i calcoli non sono molto giusti
    with Locations((key_w/2, - n_rows*key_w - max_offset + key_w/2 + key_col_offsets[0])):
        Rectangle(key_w, key_w*2)
    with Locations(((n_cols-0.5)*key_w, -n_rows*key_w - max_offset + key_w/2 + key_col_offsets[n_cols-1])):
        Rectangle(key_w, key_w*2)
    make_hull()

    # Thumb matrix
    with Locations(thumb_locs):
        Rectangle(key_w, key_w)
    # 2. Area Pollici (Arco creato con hull a coppie)
    # NOTE: agigustare, magari usare una funzione che crea un arco 2d di semicerchio dove ci sono i tasti, adesso non funziona molto bene...
    for i in range(len(thumb_locs) - 1):
        # Usiamo add() per unire i segmenti man mano
        with BuildSketch() as segment:
            with Locations(thumb_locs[i], thumb_locs[i+1]):
                Rectangle(key_w, key_w)
            make_hull()
        add(segment)

    # TODO: fare che i tasti sinistra del pollice si colleghino con la parte alta della tastiera tramite un rettangolo pieno sempre (una proiezione)

    # Area microcontrollore:
    dx = n_cols * key_w
    dy = -n_rows * key_w - key_col_offsets[n_cols-1] - key_w/2
    pts = [
        Vector(-key_w/10, 0),
        Vector(-key_w/10, key_w*n_rows - key_col_offsets[n_cols-1] + max_offset),
        Vector(util_w, key_w*n_rows - key_col_offsets[n_cols-1] + max_offset),
        Vector(util_w, -key_w)
    ]
    with Locations((dx, dy)):
        Polygon(pts, align=None)

    # Full fillets
    fillet(keys_matrix.vertices(), radius=outer_radius)

# Show keys outlines
quadrati = []
for p in finger_locs:
    # Creiamo un Wire (perimetro) per ogni posizione
    # Spostandolo manualmente nella posizione p
    q = Wire.make_rect(key_w, key_w).moved(Location(p))
    quadrati.append(q)

# ==========================================
# EXPORT
# ==========================================

#show(keys_matrix) # solo l'interno
#show(keys_matrix.edges()) # Outline completo
show(keys_matrix, keys_matrix.edges(), quadrati, colors=["gray", "green", "red"])
#keys_matrix_outlines.edges()

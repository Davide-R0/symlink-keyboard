from skidl import *

# Create input & output voltages and ground reference
vin, vout, gnd = Net('VI'), Net('VO'), Net('GND')

# Create two resistors with values and footprints
r1, r2 = 2 * Part("Device", 'R', dest=TEMPLATE, footprint='Resistor_SMD.pretty:R_0805_2012Metric')
r1.value, r2.value = '1K', '500'

# Connect the circuit elements.
vin & r1 & vout & r2 & gnd

# Or connect pin-by-pin if you prefer
# vin += r1[1]
# vout += r1[2], r2[1] 
# gnd += r2[2]

# Check for errors and generate netlist
ERC()
generate_netlist(tool=KICAD9)
generate_graph(engine='dot')
generate_dot()


#  # Create part templates
#  q = Part("Device", "Q_PNP_BRT", dest=TEMPLATE) # CBE
#  r = Part("Device", "R", dest=TEMPLATE)
#  
#  # Create nets
#  gnd, vcc = Net("GND"), Net("VCC")
#  a, b, a_and_b = Net("A"), Net("B"), Net("A_AND_B")
#  
#  # Instantiate parts
#  gndt = Part("power", "GND")             # Ground terminal
#  vcct = Part("power", "VCC")             # Power terminal
#  q1, q2 = q(2)                           # Two transistors
#  r1, r2, r3, r4, r5 = r(5, value="10K")  # Five 10K resistors
#  
#  # Make connections - notice the readable topology
#  a & r1 & q1["B C"] & r4 & q2["B C"] & a_and_b & r5 & gnd
#  b & r2 & q1["B"]
#  q1["C"] & r3 & gnd
#  vcc += q1["E"], q2["E"], vcct
#  gnd += gndt
#  
#  #generate_netlist(tool=KICAD9)
#  generate_graph(engine='dot')
#  generate_dot()

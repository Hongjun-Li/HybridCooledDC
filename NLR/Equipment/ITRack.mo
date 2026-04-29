within NLR.Equipment;
model ITRack "Simplified data center rack"
  extends Buildings.BaseClasses.BaseIcon;
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a
          =0.40) "Propylene glycol water, 40% mass fraction",
    final m_flow_nominal=mrack_flow_nominal,
    V=v,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=2)
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
    parameter Modelica.Units.SI.MassFlowRate mrack_flow_nominal
    "Nominal mass flow rate at Racks";
    parameter Real v=3
    "Volume of rack [m3]";
    parameter Real tcduretset = 273.15 + 50 "CDU Return Set Temperature [K]";
  Modelica.Blocks.Interfaces.RealInput u annotation (Placement(transformation(
          rotation=0, extent={{-98,-10},{-79,10}}),   iconTransformation(extent={{-97,-9},
            {-79,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a
          =0.40))
    annotation (Placement(transformation(extent={{2,-90},{22,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a
          =0.40))
    annotation (Placement(transformation(extent={{-18,-90},{2,-70}})));
equation
  connect(vol.heatPort, prescribedHeatFlow.port)
    annotation (Line(points={{-8,0},{-20,0}},    color={191,0,0}));
  connect(u, prescribedHeatFlow.Q_flow)
    annotation (Line(points={{-88.5,0},{-40,0}},  color={0,0,127}));
  connect(port_b, vol.ports[1]) annotation (Line(points={{12,-80},{12,-10},{1,-10}},
                 color={0,127,255}));
  connect(port_a, vol.ports[2]) annotation (Line(points={{-8,-80},{-8,-10},{3,-10}},
                 color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-80,-80},{80,80}})),    Icon(
        coordinateSystem(extent={{-80,-80},{80,80}}),     graphics={
                              Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineThickness=1)}));
end ITRack;

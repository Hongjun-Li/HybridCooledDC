within DataCentersConfigurations.Controls.obsolete.CHWPump;
model Control
  parameter Real dpnominal = 80000 "Nominal Differential Pressure [Pa]";
  Modelica.Blocks.Math.Gain gai1(k=1/dpnominal)
                                               "Gain effect"
    annotation (Placement(transformation(extent={{12,-12},{-12,12}},
        rotation=270,
        origin={0,-36})));
  Buildings.Controls.Continuous.LimPID pumSpe(
    Ti=40,
    yMin=0.2,
    k=0.1)
    "Pump speed controller"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Modelica.Blocks.Sources.Constant dpSetSca(k=1)
    "Scaled differential pressure setpoint"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Interfaces.RealInput dp annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-104})));
  Modelica.Blocks.Interfaces.RealOutput u
    annotation (Placement(transformation(extent={{96,0},{116,20}})));
equation
  connect(gai1.y, pumSpe.u_m)
    annotation (Line(points={{0,-22.8},{0,-2}}, color={0,0,127}));
  connect(dpSetSca.y, pumSpe.u_s)
    annotation (Line(points={{-39,10},{-12,10}}, color={0,0,127}));
  connect(dp, gai1.u)
    annotation (Line(points={{0,-104},{0,-50.4}}, color={0,0,127}));
  connect(pumSpe.y, u)
    annotation (Line(points={{11,10},{106,10}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Control;

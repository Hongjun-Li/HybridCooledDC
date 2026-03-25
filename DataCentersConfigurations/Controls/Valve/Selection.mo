within DataCentersConfigurations.Controls.Valve;
model Selection
  Modelica.Blocks.Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
  Modelica.Blocks.Tables.CombiTable1Ds AmbientTemp1(table=[1,1; 2,1; 3,1; 4,0;
        5,0; 6,0; 7,1; 8,1; 9,1; 10,0; 11,0; 12,0])
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean1
    annotation (Placement(transformation(extent={{-16,-8},{0,8}})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{20,-8},{36,8}})));
  Modelica.Blocks.Interfaces.RealOutput V
    annotation (Placement(transformation(extent={{94,-10},{114,10}})));
  Modelica.Blocks.Interfaces.RealInput TCWDry
    annotation (Placement(transformation(extent={{-120,-70},{-80,-30}})));
  Modelica.Blocks.Interfaces.RealInput TCWWet
    annotation (Placement(transformation(extent={{-120,30},{-80,70}})));
equation
  connect(u, AmbientTemp1.u)
    annotation (Line(points={{-100,0},{-60,0}}, color={0,0,127}));
  connect(AmbientTemp1.y[1], realToBoolean1.u)
    annotation (Line(points={{-37,0},{-17.6,0}}, color={0,0,127}));
  connect(switch2.u2, realToBoolean1.y)
    annotation (Line(points={{18.4,0},{0.8,0}}, color={255,0,255}));
  connect(switch2.y, V)
    annotation (Line(points={{36.8,0},{104,0}}, color={0,0,127}));
  connect(TCWWet, switch2.u1) annotation (Line(points={{-100,50},{12,50},{12,
          6.4},{18.4,6.4}}, color={0,0,127}));
  connect(TCWDry, switch2.u3) annotation (Line(points={{-100,-50},{12,-50},{12,
          -6.4},{18.4,-6.4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Selection;

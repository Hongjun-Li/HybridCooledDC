within DataCentersConfigurations.Controls.obsolete.ChiWSE;
model Validation
  ChiWSEControl chiWSEControl
    annotation (Placement(transformation(extent={{-22,-14},{22,28}})));
  Modelica.Blocks.Sources.Constant dp(k=80000)
    annotation (Placement(transformation(extent={{-58,-58},{-38,-38}})));
  Modelica.Blocks.Sources.Constant v3(k=0)
    annotation (Placement(transformation(extent={{-80,22},{-60,42}})));
  Modelica.Blocks.Sources.Constant v4(k=0)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
equation
  connect(dp.y, chiWSEControl.dp)
    annotation (Line(points={{-37,-48},{0,-48},{0,-16.52}}, color={0,0,127}));
  connect(v3.y, chiWSEControl.v5) annotation (Line(points={{-59,32},{-32,32},{
          -32,15.4},{-22,15.4}},
                             color={0,0,127}));
  connect(v4.y, chiWSEControl.v4) annotation (Line(points={{-59,-10},{-32,-10},
          {-32,-1.4},{-22,-1.4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Validation;

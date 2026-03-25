within DataCentersConfigurations.Controls.obsolete.Overall;
model Validation
  parameter Real dpnominal = 80000 "Nominal Differential Pressure [Pa]";
  parameter Real tchwsupset = 273.15 + 12 "Chilled Water Supply Setpoint [K]";
  parameter Real tairsupset = 273.15 + 18 "Air Supply Setpoint [K]";
  parameter Real tairretset = 273.15 + 25 "Air Return Setpoint [K]";
  Modelica.Blocks.Sources.Constant const(k=8)
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  OverallControl overallControl(
    tchwsupset=tchwsupset,
    tairsupset=tairsupset,
    tairretset=tairretset,
    AHU(tairsupset=tairsupset, tairretset=tairretset))
    annotation (Placement(transformation(extent={{-60,2},{-40,22}})));
  Modelica.Blocks.Sources.Constant dp(k=80000)
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Modelica.Blocks.Sources.Constant TairRet(k=tairretset)
    annotation (Placement(transformation(extent={{-96,-32},{-88,-24}})));
  Modelica.Blocks.Sources.Constant TairSup(k=tairsupset)
    annotation (Placement(transformation(extent={{-96,-20},{-88,-12}})));
equation
  connect(const.y, overallControl.u) annotation (Line(points={{-79,20},{-70,20},
          {-70,21.375},{-60,21.375}}, color={0,0,127}));
  connect(dp.y, overallControl.dp) annotation (Line(points={{-79,-50},{-44,-50},
          {-44,2.125}},             color={0,0,127}));
  connect(TairRet.y, overallControl.Tret) annotation (Line(points={{-87.6,-28},
          {-48,-28},{-48,1.875}},     color={0,0,127}));
  connect(overallControl.Tsup, TairSup.y) annotation (Line(points={{-50,1.875},
          {-50,-16},{-87.6,-16}},   color={0,0,127}));
  connect(overallControl.TCWSup, TairSup.y) annotation (Line(points={{-58,2.125},
          {-60,2.125},{-60,-16},{-87.6,-16}}, color={0,0,127}));
  connect(overallControl.TCWRet, TairRet.y) annotation (Line(points={{-56,2.125},
          {-56,-28},{-87.6,-28}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Validation;

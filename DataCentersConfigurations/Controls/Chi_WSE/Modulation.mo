within DataCentersConfigurations.Controls.Chi_WSE;
model Modulation
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(table=[1,1,0; 2,1,1; 3,0,1;
        4,0,1; 5,1,0; 6,1,1; 7,1,1; 8,0,1; 9,1,0; 10,1,0; 11,1,1; 12,0,1; 13,1,
        1; 14,0,1; 15,1,0])
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Modelica.Blocks.Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
  Modelica.Blocks.Interfaces.RealOutput WSEActivate
    annotation (Placement(transformation(extent={{96,42},{116,62}})));
  Modelica.Blocks.Interfaces.RealOutput ChiActivate
    annotation (Placement(transformation(extent={{96,-50},{116,-30}})));
equation
  connect(u, combiTable1Ds.u)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,0,127}));
  connect(combiTable1Ds.y[1], WSEActivate) annotation (Line(points={{13,0},{92,
          0},{92,52},{106,52}}, color={0,0,127}));
  connect(combiTable1Ds.y[2], ChiActivate) annotation (Line(points={{13,0},{92,
          0},{92,-40},{106,-40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Modulation;

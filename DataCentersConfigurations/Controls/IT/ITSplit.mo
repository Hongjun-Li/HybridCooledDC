within DataCentersConfigurations.Controls.IT;
model ITSplit
  Modelica.Blocks.Interfaces.RealInput u annotation (Placement(transformation(
          extent={{-112,-10},{-92,10}}), iconTransformation(extent={{-110,80},{
            -90,100}})));
  Modelica.Blocks.Tables.CombiTable1Ds Architecture(table=[1,0.5,0; 2,0.5,0; 3,
        0.5,0; 4,0.125,0; 5,0.5,0; 6,0.5,0; 7,0,0.5; 8,0,0.5; 9,0,0.5; 10,0,0.5;
        11,0,0.5; 12,0,0.5], extrapolation=Modelica.Blocks.Types.Extrapolation.NoExtrapolation)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y[2]
    annotation (Placement(transformation(extent={{96,-10},{116,10}})));
equation
  connect(u, Architecture.u)
    annotation (Line(points={{-102,0},{-12,0}}, color={0,0,127}));
  connect(Architecture.y, y)
    annotation (Line(points={{11,0},{106,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ITSplit;

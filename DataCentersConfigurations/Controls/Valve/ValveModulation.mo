within DataCentersConfigurations.Controls.Valve;
model ValveModulation
  Modelica.Blocks.Tables.CombiTable1Ds ArchitectureSelection(table=[1,1,0,1,0,1,
        0,1; 2,1,0,1,1,1,0,1; 3,1,0,1,1,0,0,1; 4,0,1,1,1,0,0,1; 5,1,0,1,1,1,0,0;
        6,1,0,1,1,0,0,0; 7,1,0,1,0,1,0,0; 8,0,0,0,1,1,1,0; 9,1,0,1,1,0,1,0; 10,
        1,0,1,1,1,1,0; 11,1,0,1,1,0,1,0; 12,0,1,1,1,1,1,0; 13,0,1,1,1,0,1,0; 14,
        0,1,1,0,1,1,0], extrapolation=Modelica.Blocks.Types.Extrapolation.NoExtrapolation)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
  Modelica.Blocks.Interfaces.RealOutput V[7]
    annotation (Placement(transformation(extent={{96,-10},{116,10}})));
equation
  connect(u, ArchitectureSelection.u)
    annotation (Line(points={{-100,0},{-12,0}}, color={0,0,127}));
  connect(ArchitectureSelection.y, V)
    annotation (Line(points={{11,0},{106,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ValveModulation;

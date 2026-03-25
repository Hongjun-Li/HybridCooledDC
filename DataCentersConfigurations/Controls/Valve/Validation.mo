within DataCentersConfigurations.Controls.Valve;
model Validation
  Valve.ValveModulation valveModulation
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
equation
  connect(const.y, valveModulation.u)
    annotation (Line(points={{-59,10},{-40,10}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(Interval=0.1, __Dymola_Algorithm="Dassl"));
end Validation;

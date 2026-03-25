within DataCentersConfigurations.Controls.IT;
model Validation
  ITSplit IT annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
equation
  connect(const.y, IT.u)
    annotation (Line(points={{-19,10},{-20,9},{-10,9}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Validation;

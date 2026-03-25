within NLR;
model Example
 extends Modelica.Icons.Example;
  System.Overall Plant
    annotation (Placement(transformation(extent={{10,-20},{70,40}})));
  Control.Control control
    annotation (Placement(transformation(extent={{-68,-20},{-8,40}})));
equation
  connect(control.Control, Plant.controlBus) annotation (Line(
      points={{-8,10},{9.75,10}},
      color={255,204,51},
      thickness=0.5));
  connect(Plant.Temperature, control.Temperature) annotation (Line(
      points={{70.25,10},{80,10},{80,-40},{-80,-40},{-80,10},{-68,10}},
      color={255,204,51},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),
                       Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})));
end Example;

within DataCentersConfigurations.Controls.obsolete.ChiWSE;
model ChiWSEControl
  parameter Real dpnominal = 80000 "Nominal Differential Pressure [Pa]";
  parameter Real tchwsupset = 273.15 + 12 "Chilled Water Supply Setpoint [K]";
  CHWPump.Control control(dpnominal=dpnominal)
    annotation (Placement(transformation(extent={{-6,-86},{8,-74}})));
  Modelica.Blocks.Interfaces.RealOutput pump
    annotation (Placement(transformation(extent={{100,-90},{120,-70}}),
        iconTransformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Interfaces.RealInput dp annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-112})));
  Modelica.Blocks.Interfaces.RealInput u annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-100,0}), iconTransformation(extent={{-120,-60},{-80,-20}})));
  Modelica.Blocks.Interfaces.RealOutput WSEbypass annotation (Placement(
        transformation(extent={{100,-30},{120,-10}}), iconTransformation(extent
          ={{100,-30},{120,-10}})));
  Modelica.Blocks.Interfaces.RealOutput Chibypass annotation (Placement(
        transformation(extent={{100,-60},{120,-40}}), iconTransformation(extent
          ={{100,-60},{120,-40}})));
  Modelica.Blocks.Sources.Constant tchwsup(k=tchwsupset)
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Interfaces.RealOutput temp
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
        iconTransformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.BooleanOutput ChiOn annotation (Placement(
        transformation(extent={{100,40},{120,60}}), iconTransformation(extent={
            {100,40},{120,60}})));
  Modelica.Blocks.Interfaces.BooleanOutput WSEOn annotation (Placement(
        transformation(extent={{100,10},{120,30}}), iconTransformation(extent={
            {100,10},{120,30}})));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(table=[1,1,0; 2,1,1; 3,0,1;
        4,0,1; 5,1,1; 6,0,1; 7,1,0; 8,0,0; 9,1,0; 10,1,1; 11,0,1; 12,1,1; 13,0,
        1; 14,1,0])
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=0.5)
    annotation (Placement(transformation(extent={{24,14},{36,26}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold1(threshold=0.5)
    annotation (Placement(transformation(extent={{24,44},{36,56}})));
  Modelica.Blocks.Interfaces.RealInput tcwsup annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-40,-112})));
  Modelica.Blocks.Interfaces.RealInput tchwret annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-80,-112})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal(realTrue=0, realFalse=1)
    annotation (Placement(transformation(extent={{80,-26},{92,-14}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal1(realTrue=0, realFalse=1)
    annotation (Placement(transformation(extent={{80,-56},{92,-44}})));
  Modelica.Blocks.Logical.LessEqual lessEqual annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,-50})));
equation
  connect(control.u, pump) annotation (Line(points={{8.42,-79.4},{8.42,-80},{
          110,-80}},
        color={0,0,127}));
  connect(dp, control.dp)
    annotation (Line(points={{0,-112},{0,-86.24},{1,-86.24}},
                                                  color={0,0,127}));
  connect(tchwsup.y,temp)  annotation (Line(points={{-59,80},{110,80}},
                color={0,0,127}));
  connect(combiTable1Ds.u, u)
    annotation (Line(points={{-14,0},{-100,0}}, color={0,0,127}));
  connect(greaterThreshold.u, combiTable1Ds.y[1])
    annotation (Line(points={{22.8,20},{16,20},{16,0},{9,0}},
                                                            color={0,0,127}));
  connect(greaterThreshold1.u, combiTable1Ds.y[2])
    annotation (Line(points={{22.8,50},{16,50},{16,0},{9,0}},
                                                            color={0,0,127}));
  connect(booleanToReal.y, WSEbypass)
    annotation (Line(points={{92.6,-20},{110,-20}}, color={0,0,127}));
  connect(booleanToReal1.y, Chibypass)
    annotation (Line(points={{92.6,-50},{110,-50}}, color={0,0,127}));
  connect(tcwsup, lessEqual.u1) annotation (Line(points={{-40,-112},{-40,-70},{
          -30,-70},{-30,-62}}, color={0,0,127}));
  connect(tchwret, lessEqual.u2) annotation (Line(points={{-80,-112},{-80,-86},
          {-22,-86},{-22,-62}}, color={0,0,127}));
  connect(greaterThreshold1.y, ChiOn)
    annotation (Line(points={{36.6,50},{110,50}}, color={255,0,255}));
  connect(booleanToReal1.u, greaterThreshold1.y) annotation (Line(points={{78.8,
          -50},{70,-50},{70,50},{36.6,50}}, color={255,0,255}));
  connect(greaterThreshold.y, WSEOn)
    annotation (Line(points={{36.6,20},{110,20}}, color={255,0,255}));
  connect(booleanToReal.u, greaterThreshold.y) annotation (Line(points={{78.8,
          -20},{66,-20},{66,20},{36.6,20}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ChiWSEControl;

within DataCentersConfigurations.Controls.CHW;
model ChiWSE
  Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingMode
    coolingMode(
    tWai=120,
    deaBan1=1.1,
    deaBan2=0.5,
    deaBan3=1.1,
    deaBan4=0.5)
    annotation (Placement(transformation(extent={{-56,-20},{0,36}})));
  Modelica.Blocks.Interfaces.RealOutput ChillerBypass annotation (Placement(
        transformation(extent={{96,50},{116,70}}), iconTransformation(extent={{96,
            50},{116,70}})));
  Modelica.Blocks.Interfaces.RealOutput WSEbypass annotation (Placement(
        transformation(extent={{96,-40},{116,-20}}), iconTransformation(extent={
            {96,-40},{116,-20}})));
  Modelica.Blocks.Interfaces.RealOutput CHWSupSet annotation (Placement(
        transformation(extent={{96,-70},{116,-50}}), iconTransformation(extent={
            {96,-70},{116,-50}})));
  Modelica.Blocks.Interfaces.RealOutput ValveWSE annotation (Placement(
        transformation(extent={{96,-10},{116,10}}), iconTransformation(extent={{
            96,-10},{116,10}})));
  Modelica.Blocks.Interfaces.RealOutput ValveChi annotation (Placement(
        transformation(extent={{96,20},{116,40}}), iconTransformation(extent={{96,
            20},{116,40}})));
  Modelica.Blocks.Interfaces.BooleanOutput Chion annotation (Placement(
        transformation(extent={{96,80},{116,100}}), iconTransformation(extent={{
            96,80},{116,100}})));
  Modelica.Blocks.Interfaces.RealInput TApp annotation (Placement(
        transformation(extent={{-120,10},{-100,30}}),iconTransformation(extent={{-120,10},
            {-100,30}})));
  Modelica.Blocks.Interfaces.RealInput TCHWSupWSE annotation (Placement(
        transformation(extent={{-120,-20},{-100,0}}),  iconTransformation(
          extent={{-120,-20},{-100,0}})));
  Modelica.Blocks.Interfaces.RealInput TCHWRetWSE annotation (Placement(
        transformation(extent={{-120,-50},{-100,-30}}), iconTransformation(
          extent={{-120,-50},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealOutput mchw annotation (Placement(
        transformation(extent={{96,-100},{116,-80}}), iconTransformation(extent
          ={{96,-100},{116,-80}})));
  Modelica.Blocks.Interfaces.RealInput TCHWSup annotation (Placement(
        transformation(extent={{-120,-80},{-100,-60}}),  iconTransformation(
          extent={{-120,-80},{-100,-60}})));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.LinearPiecewiseTwo
    linPieTwo(
    x0=0,
    x2=1,
    x1=0.5,
    y11=1,
    y21=273.15 + 5.56,
    y10=0.2,
    y20=273.15 + 22) "Translate the control signal for chiller setpoint reset"
    annotation (Placement(transformation(extent={{-36,-76},{-24,-64}})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{-84,-60},{-64,-80}})));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.TrimAndRespondContinuousTimeApproximation
    triAndRes
    "Continuous time approximation for trim and respond controller"
    annotation (Placement(transformation(extent={{-58,-76},{-46,-64}})));
  Modelica.Blocks.Math.Gain gain(k=20*6485)
    annotation (Placement(transformation(extent={{44,-94},{52,-86}})));
  Modelica.Blocks.Interfaces.RealInput u annotation (Placement(transformation(
          extent={{-120,40},{-100,60}}), iconTransformation(extent={{-120,40},{
            -100,60}})));
  Buildings.BoundaryConditions.WeatherData.Bus
                                     weaBus
    annotation (Placement(transformation(extent={{-114,80},{-94,100}}),
        iconTransformation(extent={{-122,70},{-102,90}})));
  Modelica.Blocks.Tables.CombiTable1Ds AmbientTemp(table=[1,1; 2,1; 3,1; 4,0; 5,
        0; 6,0; 7,1; 8,1; 9,1; 10,0; 11,0; 12,0])
    annotation (Placement(transformation(extent={{-88,68},{-80,76}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean
    annotation (Placement(transformation(extent={{-74,68},{-66,76}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-48,68},{-40,76}})));
  Modelica.Blocks.Tables.CombiTable1Ds TCHWSupset(table=[1,287.15; 2,287.15; 3,
        287.15; 4,287.15; 5,287.15; 6,287.15; 7,300.15; 8,300.15; 9,300.15; 10,
        300.15; 11,300.15; 12,300.15])
    annotation (Placement(transformation(extent={{-88,36},{-80,44}})));
  Modulation modulation
    annotation (Placement(transformation(extent={{28,-20},{74,36}})));
equation
  connect(TApp, coolingMode.TApp) annotation (Line(points={{-110,20},{-74,20},{
          -74,8},{-61.6,8}},
                         color={0,0,127}));
  connect(TCHWSupWSE, coolingMode.TCHWSupWSE) annotation (Line(points={{-110,
          -10},{-74,-10},{-74,-3.2},{-61.6,-3.2}},
                                              color={0,0,127}));
  connect(TCHWRetWSE, coolingMode.TCHWRetWSE) annotation (Line(points={{-110,
          -40},{-74,-40},{-74,-14.4},{-61.6,-14.4}},
                                                color={0,0,127}));
  connect(feedback.y,triAndRes. u) annotation (Line(
      points={{-65,-70},{-59.2,-70}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(triAndRes.y,linPieTwo. u)
    annotation (Line(points={{-45.4,-70},{-37.2,-70}},
                                                     color={0,0,127}));
  connect(feedback.u1, TCHWSup)
    annotation (Line(points={{-82,-70},{-110,-70}}, color={0,0,127}));
  connect(linPieTwo.y[1], gain.u) annotation (Line(points={{-23.4,-70.27},{
          -23.4,-70},{0,-70},{0,-90},{43.2,-90}},
                             color={0,0,127}));
  connect(gain.y, mchw)
    annotation (Line(points={{52.4,-90},{106,-90}}, color={0,0,127}));
  connect(CHWSupSet, linPieTwo.y[2]) annotation (Line(points={{106,-60},{0,-60},
          {0,-70},{-22,-70},{-22,-69.97},{-23.4,-69.97}},
                                             color={0,0,127}));
  connect(AmbientTemp.y[1], realToBoolean.u)
    annotation (Line(points={{-79.6,72},{-74.8,72}}, color={0,0,127}));
  connect(realToBoolean.y, switch1.u2)
    annotation (Line(points={{-65.6,72},{-48.8,72}}, color={255,0,255}));
  connect(switch1.y, coolingMode.TWetBul) annotation (Line(points={{-39.6,72},{
          -30,72},{-30,60},{-74,60},{-74,19.2},{-61.6,19.2}},
                                                            color={0,0,127}));
  connect(weaBus.TWetBul, switch1.u1) annotation (Line(
      points={{-103.95,90.05},{-80,90.05},{-80,90},{-56,90},{-56,76},{-48.8,76},
          {-48.8,75.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.TDryBul, switch1.u3) annotation (Line(
      points={{-103.95,90.05},{-56,90.05},{-56,68},{-48.8,68},{-48.8,68.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(AmbientTemp.u, u) annotation (Line(points={{-88.8,72},{-96,72},{-96,
          50},{-110,50}}, color={0,0,127}));
  connect(TCHWSupset.u, u) annotation (Line(points={{-88.8,40},{-96,40},{-96,50},
          {-110,50}}, color={0,0,127}));
  connect(TCHWSupset.y[1], coolingMode.TCHWSupSet) annotation (Line(points={{-79.6,
          40},{-74,40},{-74,30.4},{-61.6,30.4}},       color={0,0,127}));
  connect(TCHWSupset.y[1], feedback.u2)
    annotation (Line(points={{-79.6,40},{-74,40},{-74,-62}}, color={0,0,127}));
  connect(coolingMode.y, modulation.u) annotation (Line(points={{2.8,-0.4},{28,
          -0.4}},          color={255,127,0}));
  connect(modulation.Archi, u)
    annotation (Line(points={{28,16.4},{20,16.4},{20,50},{-110,50}},
                                                            color={0,0,127}));
  connect(modulation.Chion, Chion) annotation (Line(points={{75.38,24.8},{80,
          24.8},{80,90},{106,90}},
                             color={255,0,255}));
  connect(modulation.ChillerBypass, ChillerBypass) annotation (Line(points={{75.38,
          16.4},{86,16.4},{86,60},{106,60}}, color={0,0,127}));
  connect(modulation.ValveChi, ValveChi) annotation (Line(points={{75.38,8},{92,
          8},{92,30},{106,30}}, color={0,0,127}));
  connect(modulation.ValveWSE, ValveWSE) annotation (Line(points={{75.38,-0.4},
          {100,-0.4},{100,0},{106,0}},
                                  color={0,0,127}));
  connect(modulation.WSEbypass, WSEbypass) annotation (Line(points={{75.38,-8.8},
          {80,-8.8},{80,-30},{106,-30}},color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ChiWSE;

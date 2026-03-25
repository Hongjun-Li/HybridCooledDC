within DataCentersConfigurations.Controls.CW;
model BypassConContrinuos
  Modelica.Blocks.Interfaces.RealInput TCWRet annotation (Placement(
        transformation(extent={{-140,-102},{-100,-60}}),
                                                      iconTransformation(
          extent={{-140,-102},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput main
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput bypass
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Sources.Constant no(k=1)
    annotation (Placement(transformation(extent={{6,-46},{18,-34}})));
  Modelica.Blocks.Interfaces.RealInput TCWSup annotation (Placement(
        transformation(extent={{-140,18},{-100,60}}), iconTransformation(
          extent={{-140,18},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput TCWSupSet annotation (Placement(
        transformation(extent={{-140,60},{-100,102}}), iconTransformation(
          extent={{-140,60},{-100,102}})));
  Modelica.Blocks.Interfaces.RealInput TCWRetSet annotation (Placement(
        transformation(extent={{-140,-62},{-100,-20}}), iconTransformation(
          extent={{-140,-62},{-100,-20}})));
  Buildings.Controls.Continuous.LimPID
                             conFan(
    k=1,
    Ti=60,
    Td=10,
    reverseActing=false,
    initType=Modelica.Blocks.Types.Init.InitialState)
    "Controller for tower fan"
    annotation (Placement(transformation(extent={{-68,72},{-52,88}})));
  Modelica.Blocks.Interfaces.RealOutput CTFan
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Buildings.Controls.Continuous.LimPID
                             conFan1(
    k=1,
    Ti=60,
    Td=10,
    reverseActing=false,
    initType=Modelica.Blocks.Types.Init.InitialState)
    "Controller for tower fan"
    annotation (Placement(transformation(extent={{-28,-8},{-12,8}})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{36,-30},{56,-50}})));
equation
  connect(main, main)
    annotation (Line(points={{110,0},{110,0}},   color={0,0,127}));
  connect(TCWSupSet, conFan.u_s) annotation (Line(points={{-120,81},{-100,81},
          {-100,80},{-69.6,80}}, color={0,0,127}));
  connect(TCWSup, conFan.u_m) annotation (Line(points={{-120,39},{-60,39},{
          -60,70.4}}, color={0,0,127}));
  connect(conFan.y, CTFan) annotation (Line(points={{-51.2,80},{110,80}},
                     color={0,0,127}));
  connect(no.y, feedback.u1) annotation (Line(points={{18.6,-40},{38,-40}},
                          color={0,0,127}));
  connect(feedback.u2, conFan1.y)
    annotation (Line(points={{46,-32},{46,0},{-11.2,0}},  color={0,0,127}));
  connect(feedback.y, bypass) annotation (Line(points={{55,-40},{110,-40}},
                           color={0,0,127}));
  connect(main, conFan1.y) annotation (Line(points={{110,0},{-11.2,0}},
                                      color={0,0,127}));
  connect(conFan1.u_s, TCWRetSet) annotation (Line(points={{-29.6,0},{-60,0},
          {-60,-41},{-120,-41}},                   color={0,0,127}));
  connect(conFan1.u_m, TCWRet)
    annotation (Line(points={{-20,-9.6},{-20,-81},{-120,-81}},
                                                           color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BypassConContrinuos;

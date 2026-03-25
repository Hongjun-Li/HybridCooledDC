within DataCentersConfigurations.Controls.AHU_CDU;
model AHU_CDU
  Modelica.Blocks.Tables.CombiTable1Ds Architecture(table=[1,1,0; 2,1,0; 3,1,0;
        4,1,0; 5,1,0; 6,1,0; 7,0,1; 8,0,1; 9,0,1; 10,0,1; 11,0,1; 12,0,1])
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-126,-20},{-86,20}})));
  Modelica.Blocks.Interfaces.RealOutput AHU_Activate
    annotation (Placement(transformation(extent={{96,30},{116,50}})));
  Modelica.Blocks.Interfaces.RealOutput CDU_Activate
    annotation (Placement(transformation(extent={{96,-50},{116,-30}})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Modelica.Blocks.Interfaces.RealOutput AHU_Bypass
    annotation (Placement(transformation(extent={{96,50},{116,70}})));
  Modelica.Blocks.Math.Feedback feedback1
    annotation (Placement(transformation(extent={{70,-50},{90,-70}})));
  Modelica.Blocks.Sources.Constant const1(k=1)
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Modelica.Blocks.Interfaces.RealOutput CDU_Bypass
    annotation (Placement(transformation(extent={{96,-70},{116,-50}})));
  Buildings.Controls.Continuous.LimPID
                             conFan(
    k=1,
    Ti=60,
    Td=10,
    yMax=1.25,
    initType=Modelica.Blocks.Types.Init.InitialState,
    reverseActing=false)
    "Controller for tower fan"
    annotation (Placement(transformation(extent={{-8,78},{4,90}})));
  Modelica.Blocks.Sources.Constant const4(k=273.15 + 25)
    annotation (Placement(transformation(extent={{-40,76},{-24,92}})));
  Modelica.Blocks.Interfaces.RealInput AHU_TMeas
    annotation (Placement(transformation(extent={{-124,50},{-84,90}})));
  Modelica.Blocks.Interfaces.RealOutput AHU_Fan
    annotation (Placement(transformation(extent={{96,74},{116,94}})));
equation
  connect(u, Architecture.u)
    annotation (Line(points={{-106,0},{-12,0}}, color={0,0,127}));
  connect(Architecture.y[1], AHU_Activate) annotation (Line(points={{11,0},{20,
          0},{20,40},{106,40}}, color={0,0,127}));
  connect(Architecture.y[2], CDU_Activate) annotation (Line(points={{11,0},{20,
          0},{20,-40},{106,-40}}, color={0,0,127}));
  connect(feedback.u2, Architecture.y[1]) annotation (Line(points={{80,52},{80,
          40},{20,40},{20,0},{11,0}}, color={0,0,127}));
  connect(const.y, feedback.u1)
    annotation (Line(points={{41,60},{72,60}}, color={0,0,127}));
  connect(feedback.y, AHU_Bypass)
    annotation (Line(points={{89,60},{106,60}}, color={0,0,127}));
  connect(feedback1.u2, Architecture.y[2]) annotation (Line(points={{80,-52},{
          80,-40},{20,-40},{20,0},{11,0}}, color={0,0,127}));
  connect(const1.y, feedback1.u1)
    annotation (Line(points={{41,-60},{72,-60}}, color={0,0,127}));
  connect(feedback1.y, CDU_Bypass)
    annotation (Line(points={{89,-60},{106,-60}}, color={0,0,127}));
  connect(const4.y,conFan. u_s) annotation (Line(points={{-23.2,84},{-9.2,84}},
                        color={0,0,127}));
  connect(AHU_TMeas, conFan.u_m)
    annotation (Line(points={{-104,70},{-2,70},{-2,76.8}},
                                                         color={0,0,127}));
  connect(conFan.y, AHU_Fan) annotation (Line(points={{4.6,84},{106,84}},
                     color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end AHU_CDU;

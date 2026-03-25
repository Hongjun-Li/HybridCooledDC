within DataCentersConfigurations.Controls.obsolete.AHU;
model control
  parameter Real tairsupset = 273.15 + 18 "Supply Air Set Point [K]";
  parameter Real tairretset = 273.15 + 25 "Return Air Set Point [K]";
  Buildings.Controls.Continuous.LimPID ahuFanSpeCon(
    k=0.1,
    reverseActing=false,
    yMin=0.01,
    Ti=240)   "Fan speed controller "
    annotation (Placement(transformation(extent={{-36,-70},{-16,-50}})));
  Modelica.Blocks.Interfaces.RealInput Tsup annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-30,-106}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-10,-106})));
  Modelica.Blocks.Interfaces.RealInput Tret annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={30,-106})));
  Modelica.Blocks.Interfaces.RealOutput fan
    annotation (Placement(transformation(extent={{96,-70},{116,-50}})));
  Modelica.Blocks.Sources.Constant tairret(k=tairretset)
    annotation (Placement(transformation(extent={{-80,-64},{-70,-54}})));
  Modelica.Blocks.Interfaces.RealInput v6 annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-110,80})));
  Modelica.Blocks.Logical.Switch AHUMaster
    annotation (Placement(transformation(extent={{-40,72},{-28,84}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=0.5)
    annotation (Placement(transformation(extent={{-74,74},{-64,84}})));
  Modelica.Blocks.Sources.Constant yes(k=1)
    annotation (Placement(transformation(extent={{-60,88},{-52,96}})));
  Modelica.Blocks.Sources.Constant no(k=0)
    annotation (Placement(transformation(extent={{-60,64},{-52,72}})));
  Modelica.Blocks.Math.Product product4
    annotation (Placement(transformation(extent={{40,-68},{54,-54}})));
  Modelica.Blocks.Interfaces.RealOutput AHUbypass
    annotation (Placement(transformation(extent={{96,18},{116,38}})));
  Modelica.Blocks.Math.Feedback feedback1
    annotation (Placement(transformation(extent={{58,30},{78,50}})));
  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{42,36},{50,44}})));
  ASE aSE(TAirSupSet=tairsupset)
    annotation (Placement(transformation(extent={{-56,-8},{-36,12}})));
  Modelica.Blocks.Interfaces.RealOutput ASEy
    annotation (Placement(transformation(extent={{96,-10},{116,10}})));
  Modelica.Blocks.Interfaces.RealInput Tdrybulb annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-66,-108}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-50,-106})));
  Modelica.Blocks.Interfaces.RealInput Tmix annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-126,-108}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-90,-106})));
equation
  connect(ahuFanSpeCon.u_s, tairret.y) annotation (Line(points={{-38,-60},{-40,
          -59},{-69.5,-59}},           color={0,0,127}));
  connect(AHUMaster.u2, lessThreshold.y) annotation (Line(points={{-41.2,78},{
          -44,79},{-63.5,79}}, color={255,0,255}));
  connect(no.y, AHUMaster.u3) annotation (Line(points={{-51.6,68},{-41.2,68},{
          -41.2,73.2}}, color={0,0,127}));
  connect(AHUMaster.u1, yes.y) annotation (Line(points={{-41.2,82.8},{-48,82.8},
          {-48,92},{-51.6,92}}, color={0,0,127}));
  connect(v6, lessThreshold.u)
    annotation (Line(points={{-110,80},{-108,79},{-75,79}}, color={0,0,127}));
  connect(product4.y, fan) annotation (Line(points={{54.7,-61},{54.7,-62},{92,
          -62},{92,-60},{106,-60}}, color={0,0,127}));
  connect(product4.u2, ahuFanSpeCon.y) annotation (Line(points={{38.6,-65.2},{
          -10,-65.2},{-10,-60},{-15,-60}}, color={0,0,127}));
  connect(product4.u1, AHUMaster.y) annotation (Line(
      points={{38.6,-56.8},{38.6,-58},{20,-58},{20,78},{-27.4,78}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(const.y,feedback1. u1)
    annotation (Line(points={{50.4,40},{60,40}},     color={0,0,127}));
  connect(feedback1.u2, AHUMaster.y) annotation (Line(points={{68,32},{68,26},{
          20,26},{20,78},{-27.4,78}}, color={0,0,127}));
  connect(feedback1.y, AHUbypass) annotation (Line(points={{77,40},{92,40},{92,
          28},{106,28}}, color={0,0,127}));
  connect(Tret, ahuFanSpeCon.u_m) annotation (Line(points={{30,-106},{30,-82},{
          -26,-82},{-26,-72}}, color={0,0,127}));
  connect(aSE.TretAir, Tret) annotation (Line(points={{-56,2},{-62,2},{-62,-82},
          {30,-82},{30,-106}}, color={0,0,127}));
  connect(aSE.ASE, ASEy) annotation (Line(points={{-35.6,2},{92,2},{92,0},{106,
          0}}, color={0,0,127}));
  connect(Tdrybulb, aSE.Tdrybulb) annotation (Line(points={{-66,-108},{-66,-68},
          {-84,-68},{-84,10},{-56,10}}, color={0,0,127}));
  connect(aSE.Tmix, Tmix) annotation (Line(points={{-56,-6},{-92,-6},{-92,-108},
          {-126,-108}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end control;

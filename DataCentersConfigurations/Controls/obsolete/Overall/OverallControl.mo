within DataCentersConfigurations.Controls.obsolete.Overall;
model OverallControl
  parameter Real dpnominal = 80000 "Nominal Differential Pressure [Pa]";
  parameter Real tcwsupset  = 273.15 + 6 "Condensor Water Supply Setpoint Temperature";
  parameter Real tfreeze  = 273.15 + 3 "Freeze Pretection Temperature";
  parameter Real tchwsupset = 273.15 + 12 "Chilled Water Supply Setpoint Temperature";
  parameter Real tairsupset = 273.15 + 18 "Air Supply Setpoint Temperature";
  parameter Real tairretset = 273.15 + 25 "Air Return Setpoint Temperature";
  parameter Real tcdusupset = 273.15 + 32 "CDU Supply Setpoint Temperature";
  parameter Real tcduretset = 273.15 + 55 "CDU Return Setpoint Temperature";
  Valve.ValveModulation          valveModulation
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  DataCentersConfigurations.Controls.obsolete.ChiWSE.ChiWSEControl
    chiWSEControl(dpnominal=dpnominal, tchwsupset=tchwsupset)
    annotation (Placement(transformation(extent={{-2,-66},{18,-46}})));
  Modelica.Blocks.Interfaces.RealInput u annotation (Placement(transformation(
          extent={{-110,80},{-90,100}}), iconTransformation(extent={{-110,80},{
            -90,100}})));
  Modelica.Blocks.Interfaces.RealOutput val[7] annotation (Placement(
        transformation(extent={{96,-20},{108,-8}}), iconTransformation(extent={{96,-20},
            {108,-8}})));
  Modelica.Blocks.Interfaces.RealOutput CHWpump annotation (Placement(
        transformation(extent={{98,-88},{110,-76}}),   iconTransformation(
          extent={{98,-88},{110,-76}})));
  Modelica.Blocks.Interfaces.RealOutput WSEbypass annotation (Placement(
        transformation(extent={{98,-88},{110,-76}}), iconTransformation(extent={{98,-88},
            {110,-76}})));
  Modelica.Blocks.Interfaces.RealOutput Chibypass annotation (Placement(
        transformation(extent={{98,-88},{110,-76}}),  iconTransformation(extent={{98,-88},
            {110,-76}})));
  Modelica.Blocks.Interfaces.RealOutput tchwsup annotation (Placement(
        transformation(extent={{98,2},{112,16}}),   iconTransformation(extent={{98,-88},
            {110,-76}})));
  Modelica.Blocks.Interfaces.BooleanOutput ChiOn annotation (Placement(
        transformation(extent={{98,-52},{110,-40}}), iconTransformation(extent={{98,-52},
            {110,-40}})));
  Modelica.Blocks.Interfaces.BooleanOutput WSEOn annotation (Placement(
        transformation(extent={{98,-52},{110,-40}}), iconTransformation(extent={{98,-52},
            {110,-40}})));
  Modelica.Blocks.Interfaces.RealInput dp annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={60,-222}), iconTransformation(
        extent={{4,4},{20,20}},
        rotation=90,
        origin={52,-230})));
  IT.ITSplit iTSplit
    annotation (Placement(transformation(extent={{-40,-210},{-20,-190}})));
  Modelica.Blocks.Interfaces.RealOutput ITAir annotation (Placement(
        transformation(extent={{98,-188},{118,-168}}), iconTransformation(
          extent={{98,-188},{110,-176}})));
  Modelica.Blocks.Interfaces.RealOutput ITLiquid annotation (Placement(
        transformation(extent={{98,-210},{118,-190}}), iconTransformation(
          extent={{98,-188},{110,-176}})));
  Modelica.Blocks.Interfaces.RealOutput AHUfan annotation (Placement(
        transformation(extent={{98,-136},{110,-124}}), iconTransformation(
          extent={{98,-136},{110,-124}})));
  Modelica.Blocks.Interfaces.RealInput Tsup annotation (Placement(
        transformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={0,-218}), iconTransformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={0,-218})));
  Modelica.Blocks.Interfaces.RealInput Tret annotation (Placement(
        transformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={20,-218}), iconTransformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={20,-218})));
  AHU.control control(tairsupset=tairsupset, tairretset=tairretset)
    annotation (Placement(transformation(extent={{-2,-134},{18,-114}})));
  Modelica.Blocks.Interfaces.RealOutput CDUactivate annotation (Placement(
        transformation(extent={{98,-170},{118,-150}}), iconTransformation(
          extent={{98,-188},{110,-176}})));
  Modelica.Blocks.Math.Feedback feedback1
    annotation (Placement(transformation(extent={{34,-170},{54,-150}})));
  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{18,-164},{26,-156}})));
  CW.CT bypassConContrinuosModular
    annotation (Placement(transformation(extent={{-2,12},{18,32}})));
  Modelica.Blocks.Interfaces.RealInput TCWSup annotation (Placement(
        transformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={-62,-222}), iconTransformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={-44,-218})));
  Modelica.Blocks.Interfaces.RealInput TCWRet annotation (Placement(
        transformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={-50,-222}), iconTransformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={-22,-218})));
  Modelica.Blocks.Sources.Constant tcwsup(k=tcwsupset)
    annotation (Placement(transformation(extent={{-90,24},{-84,30}})));
  Modelica.Blocks.Sources.Constant tcwret_freeze(k=tfreeze)
    annotation (Placement(transformation(extent={{-90,14},{-84,20}})));
  Modelica.Blocks.Interfaces.RealOutput CTbypass
                                                annotation (Placement(
        transformation(extent={{98,70},{110,82}}),  iconTransformation(extent={{98,70},
            {110,82}})));
  Modelica.Blocks.Interfaces.RealOutput WCT annotation (Placement(
        transformation(extent={{98,70},{110,82}}), iconTransformation(extent={{98,70},
            {110,82}})));
  Modelica.Blocks.Interfaces.RealOutput DCT annotation (Placement(
        transformation(extent={{98,70},{110,82}}), iconTransformation(extent={{98,70},
            {110,82}})));
  Modelica.Blocks.Interfaces.RealOutput CTFan annotation (Placement(
        transformation(extent={{98,76},{110,88}}), iconTransformation(extent={{98,70},
            {110,82}})));
  Modelica.Blocks.Interfaces.RealOutput AHUbypass
                                                 annotation (Placement(
        transformation(extent={{98,-96},{110,-84}}), iconTransformation(extent={{98,-136},
            {110,-124}})));
  Modelica.Blocks.Interfaces.RealInput tchwret annotation (Placement(
        transformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={-72,-222}), iconTransformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={-64,-218})));
  Modelica.Blocks.Interfaces.RealOutput ASE annotation (Placement(
        transformation(extent={{98,-124},{110,-112}}), iconTransformation(
          extent={{98,-136},{110,-124}})));
  Modelica.Blocks.Interfaces.RealInput tdrybulb
                                               annotation (Placement(
        transformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={-84,-222}), iconTransformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={-82,-218})));
  Modelica.Blocks.Interfaces.RealInput tmix annotation (Placement(
        transformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={-96,-222}), iconTransformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={-98,-218})));
equation
  connect(u, valveModulation.u) annotation (Line(points={{-100,90},{-76,90},{
          -76,90},{-60,90}}, color={0,0,127}));
  connect(val, valveModulation.V) annotation (Line(points={{102,-14},{-20,-14},
          {-20,90},{-39.4,90}},color={0,0,127}));
  connect(chiWSEControl.temp, tchwsup) annotation (Line(points={{19,-48},{78,
          -48},{78,9},{105,9}}, color={0,0,127}));
  connect(chiWSEControl.ChiOn, ChiOn) annotation (Line(points={{19,-51},{80,-51},
          {80,-46},{104,-46}}, color={255,0,255}));
  connect(chiWSEControl.WSEOn, WSEOn) annotation (Line(points={{19,-54},{82,-54},
          {82,-46},{104,-46}}, color={255,0,255}));
  connect(chiWSEControl.WSEbypass, WSEbypass) annotation (Line(points={{19,-58},
          {96,-58},{96,-82},{104,-82}}, color={0,0,127}));
  connect(chiWSEControl.Chibypass, Chibypass) annotation (Line(points={{19,-61},
          {94,-61},{94,-82},{104,-82}}, color={0,0,127}));
  connect(chiWSEControl.pump, CHWpump) annotation (Line(points={{19,-64},{90,
          -64},{90,-82},{104,-82}},   color={0,0,127}));
  connect(dp, chiWSEControl.dp) annotation (Line(points={{60,-222},{60,-67.2},{
          8,-67.2}},       color={0,0,127},
      pattern=LinePattern.Dash));
  connect(iTSplit.u, u) annotation (Line(points={{-40,-191},{-40,-190},{-66,
          -190},{-66,90},{-100,90}},
                              color={0,0,127}));
  connect(iTSplit.y[1], ITAir) annotation (Line(points={{-19.4,-200.25},{94,
          -200.25},{94,-178},{108,-178}}, color={0,0,127}));
  connect(iTSplit.y[2], ITLiquid) annotation (Line(points={{-19.4,-199.75},{94,-199.75},
          {94,-200},{108,-200}},          color={0,0,127}));
  connect(control.Tsup, Tsup) annotation (Line(points={{7,-134.6},{7,-208},{0,
          -208},{0,-218}}, color={0,0,127}));
  connect(Tret, control.Tret) annotation (Line(points={{20,-218},{20,-188},{11,-188},
          {11,-134.6}},       color={0,0,127}));
  connect(control.fan, AHUfan) annotation (Line(points={{18.6,-130},{104,-130}},
                                           color={0,0,127}));
  connect(control.v6, valveModulation.V[6]) annotation (Line(points={{-3,-116},
          {-30,-116},{-30,90.2857},{-39.4,90.2857}}, color={0,0,127}));
  connect(feedback1.y, CDUactivate)
    annotation (Line(points={{53,-160},{108,-160}}, color={0,0,127}));
  connect(feedback1.u2, valveModulation.V[7]) annotation (Line(points={{44,-168},
          {44,-176},{-30,-176},{-30,90.4286},{-39.4,90.4286}}, color={0,0,127}));
  connect(const.y, feedback1.u1)
    annotation (Line(points={{26.4,-160},{36,-160}}, color={0,0,127}));
  connect(bypassConContrinuosModular.Archi_Selection, valveModulation.V[1])
    annotation (Line(points={{-4,31.7},{-30,31.7},{-30,89.5714},{-39.4,89.5714}},
        color={0,0,127}));
  connect(bypassConContrinuosModular.TCWRet, TCWRet) annotation (Line(points={{-4,12.9},
          {-50,12.9},{-50,-222}},          color={0,0,127}));
  connect(bypassConContrinuosModular.TCWSup, TCWSup) annotation (Line(points={{-4,22.1},
          {-62,22.1},{-62,-222}},          color={0,0,127}));
  connect(tcwsup.y, bypassConContrinuosModular.TCWSupSet) annotation (Line(
        points={{-83.7,27},{-12,27},{-12,26.7},{-4,26.7}}, color={0,0,127}));
  connect(tcwret_freeze.y, bypassConContrinuosModular.TCWRetSet) annotation (
      Line(points={{-83.7,17},{-82,17.3},{-4,17.3}},        color={0,0,127}));
  connect(bypassConContrinuosModular.bypass, CTbypass) annotation (Line(points={{19,18},
          {88,18},{88,76},{104,76}},          color={0,0,127}));
  connect(bypassConContrinuosModular.WCT, WCT) annotation (Line(points={{19,22.2},
          {86,22.2},{86,76},{104,76}},       color={0,0,127}));
  connect(bypassConContrinuosModular.DCT, DCT) annotation (Line(points={{19,25.4},
          {84,25.4},{84,76},{104,76}},       color={0,0,127}));
  connect(bypassConContrinuosModular.CTFan, CTFan) annotation (Line(points={{
          18.9,30.3},{82,30.3},{82,82},{104,82}}, color={0,0,127}));
  connect(control.AHUbypass, AHUbypass) annotation (Line(points={{18.6,-121.2},{
          24,-121.2},{24,-118},{80,-118},{80,-90},{104,-90}}, color={0,0,127}));
  connect(u, chiWSEControl.u) annotation (Line(points={{-100,90},{-66,90},{-66,
          -60},{-2,-60}}, color={0,0,127}));
  connect(tchwret, chiWSEControl.tchwret) annotation (Line(points={{-72,-222},{
          -72,-74},{0,-74},{0,-67.2}}, color={0,0,127}));
  connect(TCWSup, chiWSEControl.tcwsup) annotation (Line(points={{-62,-222},{
          -62,-76},{4,-76},{4,-67.2}}, color={0,0,127}));
  connect(control.ASEy, ASE) annotation (Line(points={{18.6,-124},{92,-124},{92,
          -118},{104,-118}}, color={0,0,127}));
  connect(tdrybulb, control.Tdrybulb) annotation (Line(points={{-84,-222},{-84,
          -166},{4,-166},{4,-134.6},{3,-134.6}}, color={0,0,127}));
  connect(tmix, control.Tmix) annotation (Line(points={{-96,-222},{-96,-142},{
          -2,-142},{-2,-134.6},{-1,-134.6}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -220},{100,100}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-220},{100,
            100}})));
end OverallControl;

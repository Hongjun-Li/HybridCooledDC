within DataCentersConfigurations.Controls.CW;
model CW
  parameter Real CW_flownominal = 30 "[kg/s]";
  parameter Real COC = 5 "Cycles of Concentration";
  parameter Real Drift = 0.001 "Drift Loss [fraction of RR, e.g., 0.1% = 0.001]";
  parameter Real Eva_Factor = 0.85 "Evaporation Factor";
  Modelica.Blocks.Interfaces.RealInput TCWRet "Condenser Water Return Temperature" annotation (Placement(
        transformation(extent={{-124,-92},{-100,-68}}),
                                                      iconTransformation(
          extent={{-124,-92},{-100,-68}})));
  Modelica.Blocks.Interfaces.RealOutput WCT "Wet Cooling Tower Activation"
    annotation (Placement(transformation(extent={{100,-20},{120,0}}),
        iconTransformation(extent={{100,-20},{120,0}})));
  Modelica.Blocks.Interfaces.RealOutput bypass "Bypass Valve Activation"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
        iconTransformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Sources.Constant no(k=1)
    annotation (Placement(transformation(extent={{0,-62},{12,-50}})));
  Modelica.Blocks.Interfaces.RealInput TCWSup "Condenser Water Supply Temperature" annotation (Placement(
        transformation(extent={{-124,-12},{-100,12}}),iconTransformation(
          extent={{-124,-12},{-100,12}})));
  Modelica.Blocks.Interfaces.RealInput TCWSupSet "Condenser Water Supply Temperature SetPoint" annotation (Placement(
        transformation(extent={{-124,28},{-100,52}}),  iconTransformation(
          extent={{-124,28},{-100,52}})));
  Modelica.Blocks.Interfaces.RealInput TCWRetSet "Condenser Water Return Temperature Setpoint" annotation (Placement(
        transformation(extent={{-124,-52},{-100,-28}}), iconTransformation(
          extent={{-124,-52},{-100,-28}})));
  Buildings.Controls.Continuous.LimPID
                             conFan(
    k=1,
    Ti=60,
    Td=10,
    reverseActing=false,
    initType=Modelica.Blocks.Types.Init.InitialState)
    "Controller for tower fan"
    annotation (Placement(transformation(extent={{-58,32},{-42,48}})));
  Modelica.Blocks.Interfaces.RealOutput CTFan "Wet Cooling Tower Fan Speed"
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
        iconTransformation(extent={{100,70},{120,90}})));
  Buildings.Controls.Continuous.LimPID Bypass(
    k=1,
    Ti=60,
    Td=10,
    reverseActing=false,
    initType=Modelica.Blocks.Types.Init.InitialState) "Controller for bypass"
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{20,-46},{40,-66}})));
  Modelica.Blocks.Math.Product Activate1
    annotation (Placement(transformation(extent={{46,74},{58,86}})));
  Modelica.Blocks.Math.Product Activate4
    annotation (Placement(transformation(extent={{46,-16},{58,-4}})));
  Modelica.Blocks.Interfaces.RealOutput DCT "Dry Cooling Tower Activation"
    annotation (Placement(transformation(extent={{100,10},{120,30}}),
        iconTransformation(extent={{100,10},{120,30}})));
  Modelica.Blocks.Math.Product Activate3
    annotation (Placement(transformation(extent={{46,14},{58,26}})));
  Modelica.Blocks.Interfaces.RealInput Archi_Selection "Architecture Selection" annotation (Placement(
        transformation(extent={{-124,68},{-100,92}}),  iconTransformation(
          extent={{-124,68},{-100,92}})));
  Modelica.Blocks.Tables.CombiTable1Ds Architecture(table=[1,1,0; 2,1,0; 3,1,0;
        4,0,1; 5,0,1; 6,0,1; 7,1,0; 8,1,0; 9,1,0; 10,0,1; 11,0,1; 12,0,1])
    annotation (Placement(transformation(extent={{-72,70},{-52,90}})));
  Modelica.Blocks.Math.Product Activate2
    annotation (Placement(transformation(extent={{46,44},{58,56}})));
  Modelica.Blocks.Interfaces.RealOutput DCTFan "Dry Cooling Tower Fan Speed"
    annotation (Placement(transformation(extent={{100,40},{120,60}}),
        iconTransformation(extent={{100,40},{120,60}})));
  Modelica.Blocks.Interfaces.RealOutput CWmassflow
    "Nominal Condenser Water Mass Flow"                                                annotation (Placement(
        transformation(extent={{100,-80},{120,-60}}), iconTransformation(extent={{100,-80},
            {120,-60}})));
  Modelica.Blocks.Sources.Constant MassFLow(k=1.1*CW_flownominal)
    annotation (Placement(transformation(extent={{46,-76},{58,-64}})));
equation
  connect(WCT, WCT)
    annotation (Line(points={{110,-10},{110,-10}},
                                               color={0,0,127}));
  connect(TCWSupSet, conFan.u_s) annotation (Line(points={{-112,40},{-59.6,40}},
                                 color={0,0,127}));
  connect(TCWSup, conFan.u_m) annotation (Line(points={{-112,0},{-50,0},{-50,
          30.4}},     color={0,0,127}));
  connect(no.y, feedback.u1) annotation (Line(points={{12.6,-56},{22,-56}},
                          color={0,0,127}));
  connect(feedback.u2, Bypass.y)
    annotation (Line(points={{30,-48},{30,-40},{-9,-40}},   color={0,0,127}));
  connect(feedback.y, bypass) annotation (Line(points={{39,-56},{88,-56},{88,
          -40},{110,-40}}, color={0,0,127}));
  connect(Bypass.u_s, TCWRetSet)
    annotation (Line(points={{-32,-40},{-112,-40}},   color={0,0,127}));
  connect(Bypass.u_m, TCWRet) annotation (Line(points={{-20,-52},{-20,-80},{
          -112,-80}},
                 color={0,0,127}));
  connect(Activate1.y, CTFan)
    annotation (Line(points={{58.6,80},{110,80}}, color={0,0,127}));
  connect(Activate1.u2, conFan.y) annotation (Line(points={{44.8,76.4},{0,76.4},
          {0,40},{-41.2,40}}, color={0,0,127}));
  connect(Activate3.y, DCT)
    annotation (Line(points={{58.6,20},{110,20}}, color={0,0,127}));
  connect(Activate4.y, WCT)
    annotation (Line(points={{58.6,-10},{110,-10}}, color={0,0,127}));
  connect(Architecture.u, Archi_Selection)
    annotation (Line(points={{-74,80},{-112,80}}, color={0,0,127}));
  connect(Activate2.u2, conFan.y) annotation (Line(points={{44.8,46.4},{0,46.4},
          {0,40},{-41.2,40}}, color={0,0,127}));
  connect(Activate2.y, DCTFan)
    annotation (Line(points={{58.6,50},{110,50}}, color={0,0,127}));
  connect(MassFLow.y, CWmassflow) annotation (Line(points={{58.6,-70},{110,-70}},
                              color={0,0,127}));
  connect(Activate4.u2, Bypass.y) annotation (Line(points={{44.8,-13.6},{40,
          -13.6},{40,-40},{-9,-40}}, color={0,0,127}));
  connect(Activate3.u2, Bypass.y) annotation (Line(points={{44.8,16.4},{0,16.4},
          {0,-40},{-9,-40}}, color={0,0,127}));
  connect(Architecture.y[1], Activate4.u1) annotation (Line(points={{-51,80},{
          -34,80},{-34,-6.4},{44.8,-6.4}}, color={0,0,127}));
  connect(Architecture.y[1], Activate1.u1) annotation (Line(points={{-51,80},{
          -34,80},{-34,83.6},{44.8,83.6}}, color={0,0,127}));
  connect(Architecture.y[2], Activate2.u1) annotation (Line(points={{-51,80},{
          -34,80},{-34,53.6},{44.8,53.6}}, color={0,0,127}));
  connect(Architecture.y[2], Activate3.u1) annotation (Line(points={{-51,80},{
          -34,80},{-34,23.6},{44.8,23.6}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
This Control is for Condenser Loop, with selection of Dry cooling tower, wet cooling tower, Bypass control and CT Fan Control.
</html>"));
end CW;

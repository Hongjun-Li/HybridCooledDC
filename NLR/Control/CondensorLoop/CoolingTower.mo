within NLR.Control.CondensorLoop;
model CoolingTower
 parameter Real TCWRetSet = 273.15 + 3.33 "Condensor Ret. Temp For Freeze Protection [K]";
  Modelica.Blocks.Sources.Constant no(k=1)
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Modelica.Blocks.Interfaces.RealInput TCWSupSet "Condenser Water Supply Temperature SetPoint" annotation (Placement(
        transformation(extent={{-78,8},{-54,32}}),     iconTransformation(
          extent={{-70,40},{-50,60}})));
  Buildings.Controls.Continuous.LimPID
                             conFan(
    k=1,
    Ti=60,
    Td=10,
    reverseActing=false,
    initType=Modelica.Blocks.Types.Init.InitialState)
    "Controller for tower fan"
    annotation (Placement(transformation(extent={{-16,12},{0,28}})));
  Buildings.Controls.Continuous.LimPID Bypass(
    k=1,
    Ti=60,
    Td=10,
    reverseActing=false,
    initType=Modelica.Blocks.Types.Init.InitialState) "Controller for bypass"
    annotation (Placement(transformation(extent={{-16,-12},{0,-28}})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{20,-40},{40,-60}})));
  Modelica.Blocks.Examples.BusUsage_Utilities.Interfaces.ControlBus Temperature
    annotation (Placement(transformation(extent={{-80,-20},{-40,20}}),
        iconTransformation(extent={{-74,-14},{-46,12}})));
  Modelica.Blocks.Examples.BusUsage_Utilities.Interfaces.ControlBus CTControl
    annotation (Placement(transformation(extent={{40,-22},{80,18}}),
        iconTransformation(extent={{46,-14},{74,12}})));
  Modelica.Blocks.Sources.Constant ReturnSet(k=TCWRetSet)
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
equation
  connect(TCWSupSet,conFan. u_s) annotation (Line(points={{-66,20},{-17.6,20}},
                                 color={0,0,127}));
  connect(no.y,feedback. u1) annotation (Line(points={{1,-50},{22,-50}},
                          color={0,0,127}));
  connect(feedback.u2,Bypass. y)
    annotation (Line(points={{30,-42},{30,-20},{0.8,-20}},  color={0,0,127}));
  connect(Temperature.TCWSup, conFan.u_m) annotation (Line(
      points={{-60,0},{-8,0},{-8,10.4}},
      color={255,204,51},
      thickness=0.5));
  connect(Temperature.TCWRet, Bypass.u_m) annotation (Line(
      points={{-60,0},{-8,0},{-8,-10.4}},
      color={255,204,51},
      thickness=0.5));
  connect(CTControl.ValveWCT, Bypass.y) annotation (Line(
      points={{60,-2},{60,-20},{0.8,-20}},
      color={255,204,51},
      thickness=0.5));
  connect(CTControl.CWBypass, feedback.y) annotation (Line(
      points={{60,-2},{60,-50},{39,-50}},
      color={255,204,51},
      thickness=0.5));
  connect(CTControl.CTFan, conFan.y) annotation (Line(
      points={{60,-2},{60,20},{0.8,20}},
      color={255,204,51},
      thickness=0.5));
  connect(ReturnSet.y, Bypass.u_s)
    annotation (Line(points={{-29,-20},{-17.6,-20}},
                                                   color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-60,-60},
            {60,60}})),                                          Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-60,-60},{60,60}})));
end CoolingTower;

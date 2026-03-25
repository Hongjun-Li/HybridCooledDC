within DataCentersConfigurations.Controls.obsolete.AHU;
model ASE
  parameter Real TAirSupSet = 273.15 + 18;
  Modelica.Blocks.Sources.Constant SATSetPoi(k=TAirSupSet)
    "Supply air temperature set point"
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
  Buildings.Applications.DataCenters.DXCooled.Controls.CoolingMode cooModCon(dT=1,
      tWai=120)
    "Cooling mode controller"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Buildings.Applications.DataCenters.DXCooled.Controls.AirsideEconomizer ecoCon(
    minOAFra=0.05,
    Ti=240,
    gai=0.5)
    "Economzier controller"
    annotation (Placement(transformation(extent={{30,34},{50,54}})));
  Modelica.Blocks.Interfaces.RealInput Tdrybulb annotation (Placement(
        transformation(extent={{-120,60},{-80,100}}),iconTransformation(extent={{-120,60},
            {-80,100}})));
  Modelica.Blocks.Interfaces.RealInput TretAir annotation (Placement(
        transformation(extent={{-120,-20},{-80,20}}),  iconTransformation(
          extent={{-120,-20},{-80,20}})));
  Modelica.Blocks.Interfaces.RealOutput ASE
    annotation (Placement(transformation(extent={{94,-10},{114,10}})));
  Modelica.Blocks.Interfaces.RealInput Tmix annotation (Placement(
        transformation(extent={{-120,-90},{-80,-50}}), iconTransformation(
          extent={{-120,-100},{-80,-60}})));
equation
  connect(SATSetPoi.y, cooModCon.TSupSet) annotation (Line(points={{-29,50},{-20,
          50},{-20,35},{-12,35}}, color={0,0,127}));
  connect(cooModCon.y, ecoCon.cooMod) annotation (Line(points={{11,30},{20,30},{
          20,38},{28,38}}, color={255,127,0}));
  connect(ecoCon.TMixAirSet, SATSetPoi.y)
    annotation (Line(points={{28,50},{-29,50}}, color={0,0,127}));
  connect(cooModCon.TOutDryBul, Tdrybulb) annotation (Line(points={{-12,30},{
          -74,30},{-74,80},{-100,80}},
                                   color={0,0,127}));
  connect(cooModCon.TRet, TretAir) annotation (Line(points={{-12,25},{-74,25},{
          -74,0},{-100,0}}, color={0,0,127}));
  connect(ecoCon.y, ASE) annotation (Line(points={{51,44},{90,44},{90,0},{104,0}},
        color={0,0,127}));
  connect(Tmix, ecoCon.TMixAirMea) annotation (Line(points={{-100,-70},{18,-70},
          {18,44},{28,44}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ASE;

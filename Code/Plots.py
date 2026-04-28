import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

def create_temperature_plots(csv_filepath):
    """
    Reads a CSV file, converts Kelvin temperatures to Celsius,
    converts time from seconds to days, and plots four subplots in a 2x2 grid.
    Uses blue for Supply (Sup) and red for Return (Ret).
    """
    try:
        # Load the dataset
        df = pd.read_csv(csv_filepath)
        
        # Verify required columns exist
        required_columns = [
            'Time', 'TWetBul', 'TCWSup', 'TCWRet', 
            'TCHWSup', 'TCDUEnt', 'TCHWRet', 
            'TAirSup', 'TAirRet', 'TCDUSup', 'TCDURet'
        ]
        
        missing = [col for col in required_columns if col not in df.columns]
        if missing:
            print(f"Error: Missing columns in CSV: {missing}")
            return

        # Constants
        K_TO_C = 273.15
        SEC_TO_DAYS = 60 * 60 * 24
        
        # Color mapping
        COLOR_SUP = 'blue'
        COLOR_RET = 'red'
        COLOR_REF = 'black'  # For reference points like WetBul
        COLOR_ENT = 'orange' # Specific color for CDU Entrance
        
        # Convert Temperature: Kelvin to Celsius
        temp_cols = [col for col in required_columns if col != 'Time']
        for col in temp_cols:
            df[col] = df[col] - K_TO_C
            
        # Convert Time: Seconds to Days
        df['TimeDays'] = df['Time'] / SEC_TO_DAYS

        # Set up the figure with 4 subplots in a 2x2 grid
        fig, axes = plt.subplots(2, 2, figsize=(8, 6))
        
        # Flatten axes for easier indexing
        ax = axes.flatten()

        # Common plot settings
        x_limit = (0, 365)

        # --- Subplot 1 (Top Left): Wetbulb and Cooling Water ---
        ax[0].plot(df['TimeDays'], df['TCWSup'], label='Supply', color=COLOR_SUP)
        ax[0].plot(df['TimeDays'], df['TCWRet'], label='Return', color=COLOR_RET)
        ax[0].plot(df['TimeDays'], df['TWetBul'], label='Wet Bulb', color=COLOR_REF, linestyle=':')
        ax[0].set_title('Condenser Loop')
        ax[0].set_ylabel('Temperature (°C)')
        ax[0].set_xlim(x_limit)
        ax[0].legend()
        ax[0].grid(False, which='both', linestyle='', alpha=0.5)

        # --- Subplot 2 (Top Right): Chilled Water and CDU Entrance ---
        ax[1].plot(df['TimeDays'], df['TCHWSup'], label='Supply', color=COLOR_SUP)
        ax[1].plot(df['TimeDays'], df['TCHWRet'], label='Return', color=COLOR_RET)
        ax[1].plot(df['TimeDays'], df['TCDUEnt'], label='Mixing', color=COLOR_ENT, linestyle='--')
        ax[1].set_title('Facility Water Supply')
        ax[1].set_ylabel('Temperature (°C)')
        ax[1].set_xlim(x_limit)
        ax[1].legend()
        ax[1].grid(False, which='both', linestyle='', alpha=0.5)

        # --- Subplot 3 (Bottom Left): Air Supply and Return ---
        ax[2].plot(df['TimeDays'], df['TAirSup'], label='Supply', color=COLOR_SUP)
        ax[2].plot(df['TimeDays'], df['TAirRet'], label='Return', color=COLOR_RET)
        ax[2].set_title('Air Delivery')
        ax[2].set_xlabel('Time (Days)')
        ax[2].set_ylabel('Temperature (°C)')
        ax[2].set_xlim(x_limit)
        ax[2].legend()
        ax[2].grid(False, which='both', linestyle='', alpha=0.5)

        # --- Subplot 4 (Bottom Right): CDU Supply and Return ---
        ax[3].plot(df['TimeDays'], df['TCDUSup'], label='Supply', color=COLOR_SUP)
        ax[3].plot(df['TimeDays'], df['TCDURet'], label='Return', color=COLOR_RET)
        ax[3].set_title('CDU Delivery')
        ax[3].set_xlabel('Time (Days)')
        ax[3].set_ylabel('Temperature (°C)')
        ax[3].set_xlim(x_limit)
        ax[3].legend()
        ax[3].grid(False, which='both', linestyle='', alpha=0.5)

        # Final layout adjustments
        plt.tight_layout()
        
        # Save or show
        output_plot = "temperature_analysis.svg"
        plt.savefig(output_plot, dpi=300)
        print(f"Plot saved successfully as {output_plot}")
        plt.show()

    except Exception as e:
        print(f"An unexpected error occurred: {e}")

def create_power_plots(csv_filepath):
    """
    Reads a CSV file and plots four subplots for power consumption in a 2x2 grid.
    Converts power from Watts to kW.
    """
    try:
        # Load the dataset
        df = pd.read_csv(csv_filepath)
        
        # Verify required columns exist
        power_columns = ['WCT', 'pumCW', 'pumCHW', 'AHU', 'AHU_hea', 'D2C_pump']
        required_columns = ['Time'] + power_columns
        
        missing = [col for col in required_columns if col not in df.columns]
        if missing:
            print(f"Error: Missing columns in CSV for power plot: {missing}")
            return

        # Constants
        SEC_TO_DAYS = 60 * 60 * 24
        W_TO_KW = 1000.0
        
        # Convert Time: Seconds to Days
        df['TimeDays'] = df['Time'] / SEC_TO_DAYS
        
        # Convert Power: Watts to kW
        for col in power_columns:
            df[col] = df[col] / W_TO_KW
            
        x_limit = (0, 365)

        # Set up the figure with 4 subplots in a 2x2 grid
        fig, axes = plt.subplots(2, 2, figsize=(8, 6))
        ax = axes.flatten()

        # --- Subplot 1: WCT and pumCW ---
        ax[0].plot(df['TimeDays'], df['WCT'], label='Cooling Tower', color='green')
        ax[0].plot(df['TimeDays'], df['pumCW'], label='Pump', color='blue', linestyle='--')
        ax[0].set_title('Condenser Loop')
        ax[0].set_ylabel('Power (kW)')
        ax[0].set_xlim(x_limit)
        ax[0].legend()
        ax[0].grid(False, alpha=0.3, linestyle='')

        # --- Subplot 2: pumCHW ---
        ax[1].plot(df['TimeDays'], df['pumCHW'], label='Pump', color='blue')
        ax[1].set_title('Facility Water Supply')
        ax[1].set_ylabel('Power (kW)')
        ax[1].set_xlim(x_limit)
        ax[1].legend()
        ax[1].grid(False, alpha=0.3, linestyle='')

        # --- Subplot 3: AHU and AHU_hea ---
        ax[2].plot(df['TimeDays'], df['AHU'], label='Fan', color='purple')
        ax[2].plot(df['TimeDays'], df['AHU_hea'], label='Heater', color='red', linestyle='--')
        ax[2].set_title('Air Cooling')
        ax[2].set_xlabel('Time (Days)')
        ax[2].set_ylabel('Power (kW)')
        ax[2].set_xlim(x_limit)
        ax[2].legend()
        ax[2].grid(False, alpha=0.3, linestyle='')

        # --- Subplot 4: D2C_pump ---
        ax[3].plot(df['TimeDays'], df['D2C_pump'], label='Pump', color='blue')
        ax[3].set_title('Liquid Cooling')
        ax[3].set_xlabel('Time (Days)')
        ax[3].set_ylabel('Power (kW)')
        ax[3].set_xlim(x_limit)
        ax[3].legend()
        ax[3].grid(False, alpha=0.3, linestyle='')

        plt.tight_layout()
        output_plot = "power_analysis.svg"
        plt.savefig(output_plot, dpi=300)
        print(f"Power plot saved successfully as {output_plot}")
        plt.show()

    except Exception as e:
        print(f"An unexpected error occurred during power plotting: {e}")

def create_pue_plot(csv_filepath):
    """
    Reads a CSV file, calculates PUE and Partial PUE (Air vs Liquid)
    based on an 800kW IT load (30% Air, 70% Liquid), and plots them.
    """
    try:
        # Load the dataset
        df = pd.read_csv(csv_filepath)
        
        # Verify columns
        infra_cols = ['WCT', 'pumCW', 'pumCHW', 'AHU', 'AHU_hea', 'D2C_pump']
        required_columns = ['Time'] + infra_cols
        
        missing = [col for col in required_columns if col not in df.columns]
        if missing:
            print(f"Error: Missing columns in CSV for PUE plot: {missing}")
            return

        # Constants
        SEC_TO_DAYS = 60 * 60 * 24
        W_TO_KW = 1000.0
        IT_TOTAL_KW = 800.0
        
        # Ratios
        RATIO_LIQUID = 0.7
        RATIO_AIR = 0.3
        
        IT_LIQUID_KW = IT_TOTAL_KW * RATIO_LIQUID
        IT_AIR_KW = IT_TOTAL_KW * RATIO_AIR
        
        # Convert Time
        df['TimeDays'] = df['Time'] / SEC_TO_DAYS
        
        # Convert Power Columns to kW
        for col in infra_cols:
            df[f"{col}_kW"] = df[col] / W_TO_KW

        # Split components:
        # Air Handling components: AHU, AHU_hea
        # Liquid Cooling components: D2C_pump
        # Common Infrastructure (Shared based on IT ratio): WCT, pumCW, pumCHW
        df['Power_Air_Only_kW'] = df['AHU_kW'] + df['AHU_hea_kW']
        df['Power_Liquid_Only_kW'] = df['D2C_pump_kW']
        df['Power_Common_kW'] = df['WCT_kW'] + df['pumCW_kW'] + df['pumCHW_kW']
        
        # Total Infrastructure
        df['TotalInfraPower_kW'] = df['Power_Air_Only_kW'] + df['Power_Liquid_Only_kW'] + df['Power_Common_kW']
        
        # Calculate PUE (Total)
        df['PUE_Total'] = (df['TotalInfraPower_kW'] + IT_TOTAL_KW) / IT_TOTAL_KW
        
        # Calculate Partial PUE (pPUE)
        # Note: Common infrastructure is shared proportionally by the IT load ratio
        df['pPUE_Air'] = (df['Power_Air_Only_kW'] + (df['Power_Common_kW'] * RATIO_AIR) + IT_AIR_KW) / IT_AIR_KW
        df['pPUE_Liquid'] = (df['Power_Liquid_Only_kW'] + (df['Power_Common_kW'] * RATIO_LIQUID) + IT_LIQUID_KW) / IT_LIQUID_KW
            
        x_limit = (0, 365)

        # Plotting
        plt.figure(figsize=(8, 6))
        plt.plot(df['TimeDays'], df['PUE_Total'], color='black', linewidth=2, label='Total PUE')
        plt.plot(df['TimeDays'], df['pPUE_Air'], color='red', linestyle='--', label='Partial PUE (Air Loop)')
        plt.plot(df['TimeDays'], df['pPUE_Liquid'], color='blue', linestyle='--', label='Partial PUE (Liquid Loop)')
        
        #plt.title(f'PUE Analysis (IT Load: {IT_TOTAL_KW} kW | 70% Liquid, 30% Air)')
        plt.xlabel('Time (Days)')
        plt.ylabel('PUE / pPUE')
        plt.xlim(x_limit)
        plt.ylim(1.0, max(df['PUE_Total'].max(), df['pPUE_Air'].max()) * 1.05) 
        
        plt.grid(False, linestyle='', alpha=0.6)
        plt.legend()
        plt.tight_layout()
        
        output_plot = "pue_analysis_split.svg"
        plt.savefig(output_plot, dpi=300)
        print(f"PUE plot saved successfully as {output_plot}")
        plt.show()

    except Exception as e:
        print(f"An unexpected error occurred during PUE plotting: {e}")

# --- PSYCHROMETRIC UTILITIES FOR WUE ---

def get_enthalpy(temp_c, is_saturated=False, wb_c=None):
    """Detailed psychrometric calculation for enthalpy of moist air (kJ/kg)."""
    def calc_psat(t):
        return 0.61121 * np.exp((18.678 - t / 234.5) * (t / (257.14 + t)))

    P_ATM = 101.325
    if is_saturated:
        p_sat = calc_psat(temp_c)
        w = 0.622 * p_sat / (P_ATM - p_sat)
        return 1.006 * temp_c + w * (2501 + 1.86 * temp_c), w
    
    if wb_c is not None:
        psat_wb = calc_psat(wb_c)
        w_s_wb = 0.622 * psat_wb / (P_ATM - psat_wb)
        h_fg_wb = 2501 - 2.326 * wb_c
        w = (h_fg_wb * w_s_wb - 1.006 * (temp_c - wb_c)) / (h_fg_wb + 1.86 * temp_c - 4.186 * wb_c)
        return 1.006 * temp_c + w * (2501 + 1.86 * temp_c), w
    return 0, 0

def create_wue_plot(csv_filepath):
    """
    Reads a CSV file, calculates WUE (L/kWh) based on Psychrometric Mass-Energy Balance,
    and plots it over time.
    """
    try:
        df = pd.read_csv(csv_filepath)
        
        # Verify columns (pumCW is used as flow rate kg/s based on draft logic)
        required_columns = ["Time", "TCWRet", "TCWSup", "PumpCW", "TWetBul"]
        missing = [col for col in required_columns if col not in df.columns]
        if missing:
            print(f"Error: Missing columns in CSV for WUE plot: {missing}")
            return

        # Calculation Constants
        COC = 5.0
        IT_LOAD_KW = 800.0
        SEC_TO_DAYS = 60 * 60 * 24
        CP_WATER = 4.186
        
        df['TimeDays'] = df['Time'] / SEC_TO_DAYS
        
        # Calculate heat rejected and evaporation
        range_rr = df["TCWRet"] - df["TCWSup"]
        heat_rejected_kw = df["PumpCW"] * CP_WATER * range_rr
        
        # Draft logic fallback for DryBulb (if missing, use constant or internal approximation)
        # Since TDryBul is not in CSV, we use the fallback evap formula from draft
        # Or look for DryBulb in columns
        db_col = next((c for c in df.columns if c.lower() in ["tdrybul", "drybulb"]), None)
        
        if db_col:
            wb_c = df["TWetBul"] - 273.15
            db_c = df[db_col] - 273.15
            h_in, w_in = get_enthalpy(db_c, wb_c=wb_c)
            t_exit = wb_c + 3.0 
            h_out, w_out = get_enthalpy(t_exit, is_saturated=True)
            delta_h = (h_out - h_in).clip(lower=2.0) 
            delta_w = (w_out - w_in).clip(lower=1e-5) 
            evap = heat_rejected_kw * (delta_w / delta_h)
            theoretical_max_evap = heat_rejected_kw / 2450.0
            evap = evap.clip(upper=theoretical_max_evap, lower=theoretical_max_evap * 0.5)
        else:
            # Fallback evap calculation from your draft
            evap = 0.00153 * df["PumpCW"] * range_rr

        drift = df["PumpCW"] * 0.0002
        divisor = (COC - 1) if COC > 1 else 1
        blowdown = (evap / divisor) - drift
        makeup_kg_per_sec = evap + blowdown.clip(lower=0) + drift
        
        # Calculate instantaneous WUE (L/kWh)
        # (kg/s * 3600 s/h) / IT_kW = L/kWh
        df['WUE'] = (makeup_kg_per_sec * 3600) / IT_LOAD_KW
            
        x_limit = (0, 365)

        # Plotting
        plt.figure(figsize=(8, 6))
        plt.plot(df['TimeDays'], df['WUE'], color='darkcyan', label='WUE')
        
        #plt.title(f'Water Usage Effectiveness (WUE) - IT Load: {IT_LOAD_KW} kW')
        plt.xlabel('Time (Days)')
        plt.ylabel('WUE (L/kWh)')
        plt.xlim(x_limit)
        #plt.ylim(0, df['WUE'].max() * 1.2 if not df['WUE'].empty else 2.0)
        plt.ylim(1.65, 1.8)
        
        plt.grid(False, linestyle='', alpha=0.6)
        plt.legend()
        plt.tight_layout()
        
        output_plot = "wue_analysis.svg"
        plt.savefig(output_plot, dpi=300)
        print(f"WUE plot saved successfully as {output_plot}")
        plt.show()

    except Exception as e:
        print(f"An unexpected error occurred during WUE plotting: {e}")

if __name__ == "__main__":
    csv_filename = 'Overall_test.csv'
    # Plot temperatures
    create_temperature_plots(csv_filename)
    # Plot power
    create_power_plots(csv_filename)
    # Plot PUE with Split
    create_pue_plot(csv_filename)
    # Plot WUE based on psychrometric logic
    create_wue_plot(csv_filename)
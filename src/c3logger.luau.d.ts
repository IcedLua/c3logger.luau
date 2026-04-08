export type styleLevel = "none" | "default" | "always" | "hyper"
export type priorityLevel = "trace" | "debug" | "info" | "danger"

export type bothTables = Record<string, any> | any[];

export type ansiStyle = "black" | "red" | "green" | "yellow" | "blue" | "magenta" | "cyan" | "white" |
                        "brightBlack" | "brightRed" | "brightGreen" | "brightYellow" | "brightBlue" | 
                        "brightMagenta" | "brightCyan" | "brightWhite" | "bold" | "underline" | "inverse"
                        | "reset"

declare class c3lObject {
    public prefix?: string;
    public level: styleLevel;
    public silent: boolean;
    public priority: priorityLevel;
    public formatting: {
        fusion: boolean,
        ansiColors: boolean,
        nextAnsi: string[],
        table: {
            uwuify: boolean,
            allFormats: boolean,
        }
    }

    /** Applies an ANSI style to the NEXT log. Resets after logging. */
    public styleNext(style: ansiStyle): void;

    /** Returns the processed arguments ready for printing. */
    public getLoggable(...args: any[]): any[];

    /** UwUifies a string based on styleLevel. */
    public stylize(text: string, level?: styleLevel): string;

    /** Ignores priority, cannot be silenced. */
    public print(...args: any[]): void;

    /** Ignores priority, can be silenced. */
    public log(...args: any[]): void;

    /** Logs ONLY if the priority level is higher or equal to the current one. */
    public logLevel(level: priorityLevel, ...args: any[]): void;

    /** Priority 0 logs. */
    public trace(...args: any[]): void;

    /** Priority 1 logs. */
    public debug(...args: any[]): void;

    /** Priority 2 logs. */
    public info(...args: any[]): void;

    /** Priority 3 logs. Cannot be silenced. */
    public warn(...args: any[]): void;

    /** Logs if 'x' is falsy. Respects priority. */
    public logAssert(x: any, ...args: any[]): void;

    /** Warns if 'x' is falsy. Respects priority. */
    public warnAssert(x: any, ...args: any[]): void;
}

interface c3loggerExports {
    new (prefix?: string, level?: styleLevel): c3lObject
}

declare const c3logger: c3loggerExports;
export default c3logger;
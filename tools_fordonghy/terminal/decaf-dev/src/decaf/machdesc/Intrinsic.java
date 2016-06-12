package decaf.machdesc;

import decaf.tac.Label;
import decaf.type.BaseType;

public final class Intrinsic {
	/**
	 * 鍒嗛厤鍐呭瓨锛屽鏋滃け璐ュ垯鑷姩閫�鍑虹▼搴�<br>
	 * 鍙傛暟: 涓鸿鍒嗛厤鐨勫唴瀛樺潡澶у皬锛堝崟浣嶄负瀛楄妭锛�<br>
	 * 杩斿洖: 璇ュ唴瀛樺潡鐨勯鍦板潃<br>
	 * 杩斿洖绫诲瀷: 鎸囬拡锛岄渶瑕佺敤VarDecl鐨刢hangeTypeTo()鍑芥暟鏇存敼绫诲瀷
	 */
	public static final Intrinsic ALLOCATE = new Intrinsic("_Alloc", 1,
			BaseType.INT);
	/**
	 * 璇诲彇涓�琛屽瓧绗︿覆锛堟渶澶�63涓瓧绗︼級<br>
	 * 杩斿洖: 璇诲埌鐨勫瓧绗︿覆棣栧湴鍧�<br>
	 * 杩斿洖绫诲瀷: string
	 */
	public static final Intrinsic READ_LINE = new Intrinsic("_ReadLine", 0,
			BaseType.STRING);
	/**
	 * 璇诲彇涓�涓暣鏁�<br>
	 * 杩斿洖: 璇诲埌鐨勬暣鏁�<br>
	 * 杩斿洖绫诲瀷: int
	 */
	public static final Intrinsic READ_INT = new Intrinsic("_ReadInteger", 0,
			BaseType.INT);
	/**
	 * 姣旇緝涓や釜瀛楃涓�<br>
	 * 鍙傛暟: 瑕佹瘮杈冪殑涓や釜瀛楃涓茬殑棣栧湴鍧�<br>
	 * 杩斿洖: 鑻ョ浉绛夊垯杩斿洖true锛屽惁鍒欒繑鍥瀎alse<br>
	 * 杩斿洖绫诲瀷: bool
	 */
	public static final Intrinsic STRING_EQUAL = new Intrinsic("_StringEqual",
			2, BaseType.BOOL);
	/**
	 * 鎵撳嵃涓�涓暣鏁�<br>
	 * 鍙傛暟: 瑕佹墦鍗扮殑鏁板瓧
	 */
	public static final Intrinsic PRINT_INT = new Intrinsic("_PrintInt", 1,
			BaseType.VOID);
	/**
	 * 鎵撳嵃涓�涓瓧绗︿覆<br>
	 * 鍙傛暟: 瑕佹墦鍗扮殑瀛楃涓�
	 */
	public static final Intrinsic PRINT_STRING = new Intrinsic("_PrintString",
			1, BaseType.VOID);
	/**
	 * 鎵撳嵃涓�涓竷灏斿��<br>
	 * 鍙傛暟: 瑕佹墦鍗扮殑甯冨皵鍙橀噺
	 */
	public static final Intrinsic PRINT_BOOL = new Intrinsic("_PrintBool", 1,
			BaseType.VOID);
	
	public static final Intrinsic DIV = new Intrinsic("_Div", 2,
			BaseType.INT);
	
	public static final Intrinsic MOD = new Intrinsic("_Mod", 2,
			BaseType.INT);
	
	/**
	 * 缁撴潫绋嬪簭<br>
	 * 鍙互浣滀负瀛愮▼搴忚皟鐢紝涔熷彲浠ョ洿鎺oto
	 */
	public static final Intrinsic HALT = new Intrinsic("_Halt", 0,
			BaseType.VOID);
	/**
	 * 鍑芥暟鍚嶅瓧
	 */
	public final Label label;
	/**
	 * 鍑芥暟鐨勫弬鏁颁釜鏁�
	 */
	public final int numArgs;
	/**
	 * 鍑芥暟杩斿洖鍊肩被鍨�
	 */
	public final BaseType type;

	/**
	 * 鏋勯�犱竴涓瀹氫箟鍑芥暟鐨勪俊鎭�
	 * 
	 * @param name
	 *            鍑芥暟鍚嶅瓧
	 * @param argc
	 *            鍙傛暟涓暟
	 * @param type
	 *            杩斿洖绫诲瀷
	 */
	private Intrinsic(String name, int numArgs, BaseType type) {
		this.label = Label.createLabel(name, false);
		this.numArgs = numArgs;
		this.type = type;
	}

}

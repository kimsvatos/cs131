import java.util.concurrent.atomic.AtomicIntegerArray;

class GetNSet implements State {
    private byte[] value;
    private byte maxval;

 // matches size and elements of value byte array
    private AtomicIntegerArray aValue; 

    GetNSet(byte[] v) {
    System.out.println("getnset initial\n"); 
        value = v; 
        int[] holderArr = new int[v.length];
        int i = 0;
        while(i < v.length){
            holderArr[i] = value[i];
            i++;
        }

        maxval = 127; 
        aValue = new AtomicIntegerArray(holderArr);
        System.out.println("getnset initial END 1\n");
    }


    GetNSet(byte[] v, byte m) { 
        System.out.println("getnset initial 2\n");
        value = v; 
        int[] holderArr = new int[v.length];
        int i = 0;
        while(i < v.length){
            holderArr[i] = value[i];
            i++;
        }

        maxval = m; 
        aValue = new AtomicIntegerArray(holderArr);
        System.out.println("getnset initial END 2\n");
    }


    public int size() { return aValue.length(); }

    public byte[] current() { 
        System.out.println("start current\n");
        value = new byte[aValue.length()];
        int i = 0; 
        while (i < aValue.length()){
            value[i] = (byte) aValue.get(i);
            i++;
        }
        System.out.println("end current\n");
        return value;

     }

    
    //public int jVal;

    public boolean swap(int i, int j) {

    //int iVal = aValue.get(i);
    //int jVal = aValue.get(j);
    //System.out.println("swap " + iVal + " " + jVal  + "\n");
	if (aValue.get(i) <= 0 || aValue.get(j) >= maxval) {
	    return false;
	}

   // public int iVal = aValue.get(i);
    aValue.set(i, aValue.get(i)-1);
    //public int jVal = aValue.get(j);
    aValue.set(j, aValue.get(j)+1);

	//value[i]--;
	//value[j]++;
	return true;
    }
}

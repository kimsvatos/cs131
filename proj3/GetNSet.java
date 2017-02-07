import java.util.concurrent.atomic.AtomicIntegerArray;

class GetNSet implements State {
    private byte[] value;
    private byte maxval;

 // matches size and elements of value byte array
    private AtomicIntegerArray aValue; 

    GetNSet(byte[] v) { 
        value = v; 
        int[] holderArr = new int[v.length];
        int i = 0;
        while(i < v.length){
            holderArr[i] = value[i];
            i++;
        }

        maxval = 127; 
        aValue = new AtomicIntegerArray(holderArr);
    }


    GetNSet(byte[] v, byte m) { 
        value = v; 
        int[] holderArr = new int[v.length];
        int i = 0;
        while(i < v.length){
            holderArr[i] = value[i];
            i++;
        }

        maxval = m; 
        aValue = new AtomicIntegerArray(holderArr);
    }


    public int size() { return aValue.length(); }

    public byte[] current() { 
        value = new byte[aValue.length()];
        int i = 0; 
        while (i < aValue.length()){
            value[i] = (byte) aValue.get(i);
            i++;
        }
        return value;

     }

    public int iVal;
    public int jVal;

    public boolean swap(int i, int j) {
    iVal = aValue.get(i);
    jVal = aValue.get(j);
	if (iVal <= 0 || jVal >= maxval) {
	    return false;
	}

   // public int iVal = aValue.get(i);
    aValue.set(i, iVal-1);
    //public int jVal = aValue.get(j);
    aValue.set(j, jVal+1);

	//value[i]--;
	//value[j]++;
	return true;
    }
}

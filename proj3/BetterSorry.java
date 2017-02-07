import java.util.concurrent.atomic.AtomicIntegerArray;

class BetterSorry implements State {
    private byte[] value;
    private byte maxval;

 // matches size and elements of value byte array
    private AtomicIntegerArray aValue; 

    BetterSorry(byte[] v) { 
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


   BetterSorry(byte[] v, byte m) { 
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

    public int oldiVal;
    public int oldjVal;

    public boolean swap(int i, int j) {
    oldiVal = aValue.getAndIncrement(i);
    oldjVal = aValue.getAndDecrement(j);
    if (oldiVal <= 0 || oldjVal >= maxval) {
        aValue.getAndIncrement(j);
        aValue.getAndDecrement(i); //back to old values
        return false;
    }

   // public int iVal = aValue.get(i);
    //aValue.set(i, iVal-1);
    //public int jVal = aValue.get(j);
   // aValue.set(j, jVal+1);

    //value[i]--;
    //value[j]++;
    return true;
    }
}
import java.util.concurrent.atomic.AtomicIntegerArray;
import java.util.concurrent.atomic.AtomicInteger;

class BetterSorry implements State {
    private AtomicInteger[] value;
    private byte maxval;

 // matches size and elements of value byte array
    //private AtomicIntegerArray aValue; 

    BetterSorry(byte[] v) { 

        value = new AtomicInteger[v.lenth]; 
       
        int i = 0;
        while(i < value.length){
            value[i] = value[i];
            i++;
        }

        maxval = 127; 
    }


   BetterSorry(byte[] v, byte m) { 

        value = new AtomicInteger[v.lenth]; 
       
        int i = 0;
        while(i < value.length){
            value[i] = value[i];
            i++;
        }

        maxval = m; 
    }


    public int size() { return value.length(); }

    public byte[] current() { 
        byte[] curr = new byte[value.length()];
        //value = new byte[aValue.length()];
        int i = 0; 
        while (i < value.length()){
            value[i] = (byte) value.get(i);
            i++;
        }
        return value;
     }

    //public int oldiVal;
    //public int oldjVal;

    public boolean swap(int i, int j) {
    //oldiVal = aValue.getAndIncrement(i);
    //oldjVal = aValue.getAndDecrement(j);
    if ( value[i].get() <= 0 || value[j].get() >= maxval) {
        //value[i].getAndIncrement();
        //value[j].getAndDecrement(); //back to old values
        return false;
    }

   // public int iVal = aValue.get(i);
    //aValue.set(i, iVal-1);
    //public int jVal = aValue.get(j);
   // aValue.set(j, jVal+1);
    value[i].getAndIncrement();
    value[j].getAndDecrement();
    //value[i]--;
    //value[j]++;
    return true;
    }
}
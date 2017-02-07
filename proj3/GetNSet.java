import java.util.concurrent.atomic.AtomicIntegerArray;

class GetNSet implements State{

    private byte maxval;
    private AtomicIntegerArray m_value;
    
    GetNSet(byte[] val) {

        int[] vl = new int[val.length];
        for (int i = 0; i < val.length; i++)
            vl[i] = val[i];
        m_value = new AtomicIntegerArray(vl); 
        maxval = 127; 
    }

    GetNSet(byte[] val, byte m) { 

        int[] vl = new int[val.length];
        for (int i = 0; i < val.length; i++)
            vl[i] = val[i];
        m_value = new AtomicIntegerArray(vl); 
        maxval = m; 
    }
    
    public int size() { return m_value.length(); }

    public byte[] current() { 

        byte[] byte_array = new byte[m_value.length()];
        for (int i = 0; i < m_value.length(); i++)
            byte_array[i] = (byte) m_value.get(i);
        return byte_array;
    }

    public boolean swap(int i, int j) {

        if (m_value.get(i) <= 0 || m_value.get(j) >= maxval)
            return false;

        m_value.set(i, m_value.get(i)-1);
        m_value.set(j, m_value.get(j)+1);
        
        return true;
    }
}

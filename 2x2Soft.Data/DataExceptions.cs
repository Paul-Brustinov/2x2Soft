﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _2x2Soft.Data
{
    public class DataLoaderException : Exception
    {
        public DataLoaderException(String message)
            : base(message)
        {
        }
    }

    public class DataWriterException : Exception
    {
        public DataWriterException(String message)
            : base(message)
        {
        }
    }
}

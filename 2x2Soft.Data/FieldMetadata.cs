﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace _2x2Soft.Data
{
    public enum DataType
    {
        Undefined,
        String,
        Number,
        Date,
        Boolean,
    }

    public enum FieldType
    {
        Scalar,
        Object,
        Array,
        Map,
        Tree
    }

    public enum SpecType
    {
        Unknown,
        Id,
        Name,
        RefId,
        ParentId,
        RowCount,
        RowNumber,
        HasChildren,
        Items
    }

    public class FieldMetadata
    {
        public DataType DataType { get; }
        public FieldType ItemType { get; } // for object, array
        public String RefObject { get; } // for object, array

        public Boolean IsArrayLike { get { return ItemType == FieldType.Object || ItemType == FieldType.Array; } }

        public FieldMetadata(FieldInfo fi, DataType type)
        {
            DataType = type;
            ItemType = FieldType.Scalar;
            RefObject = null;
            if (fi.IsObjectLike)
            {
                ItemType = fi.FieldType;
                RefObject = fi.TypeName;
            }
            else if (fi.IsRefId)
            {
                ItemType = FieldType.Object;
                RefObject = fi.TypeName;
            }
        }
    }
}
